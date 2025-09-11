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
jq 'map(select(.comment | test("test"; "i") | not))' test2.json

