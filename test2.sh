# echo '2025-09-07' | jq -R 'match("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})") 
# | .captures
# | map({key: .name, value: .string  }) | map(.)'
 
# echo 'ip 10.1.2.3 mask 255.255.255.0' | 
#   jq -R 'match("(?<octet>\\d{1,3})"; "g") | .captures(.captures[0].string) 
# '

# echo 'ip 10.1.2.3 mask 255.255.255.0' | jq -R '
#   [match("(?<octet>\\d{1,3})"; "g")] | map(.captures)[2]
# '

# echo '2025-09-23' | jq -R '
#   capture("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})") 
# '

# echo 'ip 10.1.2.3 mask 255.255.255.0' | jq -R '
#   capture("(?<octet>\\d{1,3})"; "g")
# '

# echo '["abcccd", "123334", "eeed", "eddd"]' | jq -R '
#   fromjson 
# '

# echo 'abcccd' | jq -R '
#   match("(?<ch>.)\\k<ch>{2}")'

# echo 'aaabbbcccaaaa' | jq -R '
#   match("(.)\\1{2}"; "g")
# '

# Detect all repeated pattern <triplet>*, and filter the captured string ( repeated n-times ) by length == 3.
#echo 'aaabbbcccaaaa' | jq -R 'match("(?<triplet>.)\\k<triplet>*"; "g") | select((.string | length) == 3)'

#jq 'map({ offset: .offset, length: .length, namearray: .captures[0].name})' test.json

echo 'aaabbbcccaaaa' | jq -R '[match("(?<triplet>.)\\k<triplet>*"; "g") | select((.string | length) == 4)] | 
  map({ "offset": .offset, "length": .length, "string": .string, int_name: .captures[0].name })
'

# echo 'abcdefabcac' | jq -R 'scan("ab")'

# echo 'abaabbaaabb' | jq -R 'scan("(a+)(bb)")'
# echo 'abaabbaaab' | jq -R 'scan("(a+)(bb)")'