# echo '2025-09-07' | jq -R 'match("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})") 
# | .captures
# | map({key: .name, value: .string  }) | map(.)'
 
# echo 'ip 10.1.2.3 mask 255.255.255.0' | jq -R '
#   [match("(?<octet>\\d{1,3})"; "g")] | map(.captures)[2]
# '

# echo '2025-09-23' | jq -R '
#   capture("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})") 
# '

## Detect all repeated pattern <triplet>*, and filter the captured string ( repeated exactly n-times, no less no more ) by length == 3.
## This is one design pattern. Appears jq executes negative look ahead so the design pattern that follows this will allow functions properly.  
#echo 'aaabbbcccaaaa' | jq -R 'match("(?<triplet>.)\\k<triplet>*"; "g") | select((.string | length) == 3)'

#jq 'map({ offset: .offset, length: .length, namearray: .captures[0].name})' test.json

## Passing a shell variable to jq for pattern size... Note a numeric variable passed to jq must be cast explicitly as a numeric value 
## before being plugged into an expression...
# REPEATCOUNT="3"
# echo 'aaabbbcccaaaa' | jq -R --arg REPEATCOUNT "$REPEATCOUNT" '[match("(?<triplet>.)\\k<triplet>*"; "g") | select((.string | length)==($REPEATCOUNT | tonumber))] | 
#   map({ "offset": .offset, "length": .length, "string": .string, int_name: .captures[0].name })
# '

## Detect all repeated pattern of variable characters and length. Uses negative look-ahead and pattern repeat. A shell variable REPEATCOUNT specifies exactly how many 
## times the pattern is repeated, no more no less. The patern is sized at 1 to maximum of 5 characters... 
## Output is dissected to form a returned json, which includes the offset, the detected string, the number of times it is repeated, 
## and details on detected pattern derived from 'captures' attribute. 
# REPEATCOUNT=2
# printf '%s\n' 'ababab abababab xyzxyzxyz aaaaaa' | 
#   jq -R --argjson REPEATCOUNT "$REPEATCOUNT" '
#     [match("(?<rep_pattern>.{1,5}?)\\k<rep_pattern>{'$REPEATCOUNT'}(?!\\k<rep_pattern>)"; "g")] | 
#     map(
#       { offset: .offset, repeated: (($REPEATCOUNT | tonumber) + 1 | tostring), detected_string: .string } + 
#       reduce .captures[] as $c ({}; . + { ($c.name): $c.string })
#     )
#   '

## Returns nodes that passes the pattern test on one of the field. test applies the condition to .comment field, and returns
## a node that fails the test. 
#jq 'map(select(.comment | test("test"; "i") | not))' test2.json

#echo '{ "a": 86, "b": 99, "k": "b"}' | jq -cs '.[.["k"]]' 
#echo '{ "a": 86, "b": 99, "k": "b"}' | jq -cs '.[0] | map(.) | .[1]' 


## Take from below snippets are 1. All input are natively list. Array must be enclosed in [] to become an array. 
# jq -n '[86, 99, 13 | . + 1 ] | map(.) | .[1]'
# jq -n '[86, 99, 13]'
# jq -n '[86, 99, 13] | .[] | type'  # Turns an array into a list, or rather extracting elements out of the array and lay them out as a list.  
# jq -n '{"name": "siegfried", "group": "kaos"} | .[]' # Turns an object into a simple list, with keys stripped. 
# jq -n '[86, 99, 13] | length'      # Applying the function length onto the array itself. 
# jq -n '[86, 99, 13] | map(length)'      # Applying the function length onto each element of the array. length(a_numeric) returns the parameter a_numeric itself. And so, the whole snippet is a identity.
# jq -n '86, 99, 13 | length'      # Applies length function to each element of the list. Output is another list. 
# jq -n '[86, 99, 13] | map(.) | type'    # Am identity. Returns the same array. 
# jq -n '86, 99, 13 | [.] | type' # Before the pipe, the input is a list. RHS of the pipe, it applies [] to each element 
# of the list, turning each element into an array. So the second pipe will feed a list of 3-arrays to type function, 
# returning a list of string "array". 
# jq -n '[86, 99, 13] | map(. + 1)'  # This works. Applying +1 to each "array" element. map only works over array, not a list?
# jq -n '86, 99, 13 | . + 1'  # This works. Applying +1 to each "list" element. You could still apply a function over a list using not array but piping it over to a function. 
# jq -n '5 | . * 2, . * 3, . + 4, . / 5'  # This also works. Applying a series of functions to a single element list via pipe. At the right hand
# side of the pipe, . "dot" represent each item of the list.
# jq -n '10, 20, 30 | . * 2, . * 3, . + 4, . / 5 '  # RHS applies a series of function at the same level to each list element.s
# jq -n '[{id: 10}, {id:20}, {id:30}] | map({dbl: (.id * 2), trip: (.id * 3), plus4:(.id + 4), div5:(.id / 5)})'  # RHS applies a series of function at the same level to each list element.s
# jq -n 'range(1;4) | {id: ., value: ("item " + (. | tostring))}' | jq -s '.'  # In the filter, '.' refers to each element in the array. 
#jq -n '[[0], [0, 1], [2, 1, 0]] | .[] as [$a, $b, $c] | [$a, $b, $c]'  # This works. .[] destructures the input arrays 
## and assigns first two elements into $a and $b.
