#jq '.resources[] as { $id, $kind, events: { $user_id, $ts }} ?// { $id, $kind, events: [{ $user_id, $ts }]} | {$user_id, $kind, $id, $ts }' test5.json
#jq '.resources[] as { $id, $kind, events: [{ $user_id, $ts }]} ?// { $id, $kind, events: { $user_id, $ts }} | {$user_id, $kind, $id, $ts }' test5.json
#jq '.resources[] as {$id, $kind, events: {$action, $user_id, $ts}} | { $id, $kind, $user_id, $ts}' test5.json
#jq '.resources[] | { id, kind } as $r | (.events | if type == "array" then . else [.] end )[] | { action, user_id, ts } + $r' test5.json

#jq '.resources[] | { id, kind } as $r | (.events | if type == "array" then . else [.] end)[] | $r + { action, user_id, ts }' test5.json


## THIS WORKS!!
# jq '[.resources[] | { id } as $r | ( .kind | ( if type == "array" then . else [.] end)[]) as $k | 
#     ( .events | ( if type == "array" then . else [.] end)[]) as $e | 
#     $r + { $k } + { $e }] ' test5.json | 
# jq '{ resources: . }' | 
# jq '.resources[] | select(.id == 1)'

## Studying patterns below, filter pattern to extract elements out of nested array could be seen. 
## Nested array element could be destructured using a nested array in the filter or even variable alias. 
# jq -n '[[3]] | .[]  as [$a] ?// $b | {$a}'   # -> { a: 3 }
# jq -n '[[3]] | .  as [[$a]] ?// $b | {$a}'   # -> { a: 3 }
# jq -n '[[[3]]] | .[] as [[$a]] ?// $b | {$a}'   # -> { a: 3 }

# jq -n '[1,2,3]'
# jq -n '[1,2,3] | def increment: . + 1; map(increment)'
# jq -n '1, 2, 3 | def increment: . + 1; increment' 
# jq -n '5 | def foo(f): f|f; foo(.*.)' 

#jq -n '[[5], [1,4]] | def addvalue(f): . + [f]; map(addvalue(.[0]))' 
#jq -n '[[5], [1,4], [10,40,50]] | def addvalue(f): map( . + [. | f]); addvalue(.[0])'

jq -n '[] | map( . as $b | isempty($b)) | isempty(.)'

