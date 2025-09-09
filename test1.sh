jq ' . | map(
  if has("role") then
    if (
        (.role | index("manager")) or         
        (.role | index("vice-president")) or 
        (.role | index("director"))
    ) then
      "OK: role matches expected value"
    else
      "Value mismatch: role=" + (.role|tostring)
    end
  else
    error("Missing key: role")
  end) | if all(. == "OK: role matches expected value") then "OK" else "Not OK" end
' users.json

echo '
[
  "OK: role matches expected value",
  "Value mismatch: role=[\"data specialist\",\"developer\"]",
  "OK: role matches expected value",
  "OK: role matches expected value",
  "OK: role matches expected value"
]
' | jq '.'

## 
jq '
def age_issues($age):
  # normalize attempt
  (try ($age|tonumber) catch null) as $n        # if $age test passes, then numeric .age value is passed as $n.. 
  | [
      (select($n == null) | {msg:"age not numeric", got:$age}),
      (select($n != null and $n < 18) | {msg:"underage", value:$n})
    ]
  | map(.)  # drop nulls but dont think in any 
;

. | map(
    {id, name} as $idname
    | (age_issues(.age)) as $issues
    | if ($issues|length) > 0
      then $idname + {errors: $issues}      
      else $idname + {age, "age_is_numeric": "age is numeric", "age_ok": (.age|tonumber)}      
      end
  )
' users.json


echo '[{"role":["staff"]}, {"role":["analyst", "dev", "staff"]}, 
    { "role": ["dev", "staff", "admin"]}, 
    {"role": ["staff", "staff", "staff"]}, 
    {"role": ["director", "staff", "manager"]}
     ]' | 
jq 'map( . | .role | any(. == "staff"))| { "result": all(.)}'


## recursive parsing of json tree of variable heights. A node may have role at more than one levels... 
## By select( . != null ) omit all nodes that the filter returns null on. 
echo '
{"users":
    [
        {"role":["staff"]}, 
        {"role":["analyst", "dev", "staff"]}, 
        { "student": {"name": "test", "role": ["mgr", "mgr2" ], "profile": { "role": ["dev", "staff", null, "admin"]}} }, 
        { "role2": "staff" }
    ]
}' | 
jq ' .. | .role? | select(. != null) '
#jq ' .. | .role? | select(. != null) | ( length > 1 and any(map( . == "staff"))))'

## By wrapping the entire filter in a pair of square bracket, forces the entire output as an array...
echo '["apple", "orange", "banana", "pineapple"]' | 
jq '[.[] | select( test("(?=n[a|e]+)[n|p]"))]'

