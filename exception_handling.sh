echo "$json1" | jq '.[] as $row | try ( ( $row.b // error("missing .b"))  + 1) catch ( "Handled: " + ($row | tostring))'

echo "$json1" | jq '.[] as $row | try ( $row + {b: (($row.b // error("missing .b")) + 1)} ) catch ( $row + {b: -999} ) | {user: .} '

# wrap output as an array of "user". The entire list is wrapped as a single object named "users".  An issue present. 
echo "$json1" | jq '.[] as $row | map(try ( $row + {b: (($row.b // error("missing .b")) + 1)} ) catch ( $row + {b: -999} ) | { "user": .} )'

# wrap output as an object containing users: []... The map() wraps objects into an array. 
echo "$json1" | jq '
    map(
        . as $row | 
        try ( 
            $row + { "b": 
                (
                    ($row.b // error("missing .b")) + 1
                )
            } 
        ) 
        catch ( $row + {"b": null} ) | {"user": .}
    ) | { "users": .} '

## adding another attribute, based on a 'access permission' that is bogus. Would not accomodate array in .role attribute.. 
echo "$json1" | jq 'map(. as $row | if $row.role == "manager" then $row + {"authorized": "ok"} else $row + {"authorized": ($row.role + " is not authorized!!")} end)'

## above line refactored to remote temp var $row... 
echo "$json1" | jq 'map(. | if .role == "manager" then . + {"authorized": "ok"} else . + {"authorized": (.role + " is not authorized!!")} end)'


## the following could accomodate array or string .role attribute. For each iteration first checks type of .role ( string | array ) and checks "manager" matches... 
echo "$json12" | jq '
map(
  if (.role | type) == "array" then
    if any(.role[]; . == "manager") then
      . + {authorized: "ok"}
    else
      . + {authorized: ((.role | join(", ")) + " are not authorized!!")}
    end
  else
    if .role == "manager" then
      . + {authorized: "ok"}
    else
      . + {authorized: (.role + " is not authorized!!")}
    end
  end
)'





