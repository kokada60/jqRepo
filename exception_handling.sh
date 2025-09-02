echo "$json1" | jq '.[] as $row | try ( ( $row.b // error("missing .b"))  + 1) catch ( "Handled: " + ($row | tostring))'

echo "$json1" | jq '.[] as $row | try ( $row + {b: (($row.b // error("missing .b")) + 1)} ) catch ( $row + {b: -999} ) | {user: .} '

# wrap output as an array of "user". The entire list is wrapped as a single object named "users".  An issue present. 
echo "$json1" | jq '.[] as $row | map(try ( $row + {b: (($row.b // error("missing .b")) + 1)} ) catch ( $row + {b: -999} )'

# wrap output as an object containing users: []... The map() wraps objects into an array. 
echo "$json1" | jq 'map(. as $row | try ( $row + {b: (($row.b // error("missing .b")) + 1)} ) catch ( $row + {b: -999} ) | {user: .}) | {users: .}'