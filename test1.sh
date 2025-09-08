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

jq '
def age_issues($age):
  # normalize attempt
  (try ($age|tonumber) catch null) as $n        # if $age test passes, then numeric .age value is passed as $n.. 
  | [
      (select($n == null) | {msg:"age not numeric", got:$age}),
      (select($n != null and $n < 18) | {msg:"underage", value:$n})
    ]
  | map(.)  # drop nulls
;

. | map(
    {id, name} as $idname
    | (age_issues(.age)) as $issues
    | if ($issues|length) > 0
      then $idname + {errors: $issues}
      else $idname + {age_ok: (.age|tonumber)}
      end
  )
' users.json
