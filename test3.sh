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

# jq -n '[[5], [1,4]] | def addvalue(f): . + [f]; map(addvalue(.[0]))' 
# jq -n '[[5], [1,4], [10,40,50]] | def addvalue(f): map( . + [. | f]); addvalue(.[0])'

# jq -n 'isempty(empty) '
# jq -n 'isempty([]) '
# jq -n '[] | map( isempty(.))'
# jq -n '[] | map( . as $b | isempty($b)) '
# jq -n '[] | map( . as $b | isempty($b)) | isempty(.)'

# jq -n '[range(0;10)] | [limit(3; .[])]'
# jq -n '[range(0;10)] | limit(3; .)'
# jq -n '[limit(3; range(0;10))]'
# jq -n '[limit(3; [0,1,2,3,4][])]'
# jq -n '[0,1,2,3,4] | [limit(3; .[])]'
#jq -n '[0,1,2,3,4] | .'
#jq -n '[{"x2":"a","y2":"b"},{"x2":"c","y2":"d"},{"x2":"e","y2":"f"}] | reduce .[] as {$x2,$y2} (null; .u += $x2 | .v += $y2) | .'
#jq -n '["foo", "bar", "baz"] | foreach .[] as $item (null; . + $item; {index: ., $item})'

#jq -n 'def recurse(f): def r: ., ( f | select(. != null) | r); r; '

#jq -n '[1, [2, [3]]] | recurse(. | type == "array") as $type | if ($type == "array") then .[] else . end ' ## This leads to infinite loop...

# jq -n '[1, [2, [3]]] | [recurse(.[]?)] | map(type)' 

#jq -n '[1, [2, [3]]] | recurse( if type == "array" then .[] else empty end )'

# jq -n '[1, [2, [3]]] | [recurse(.[]?) | arrays]' 
# jq -n '[1, [2, [3]]] | [recurse(.[]?) | scalars]' 
#jq -n '[1,2,3] | reduce .[] as $x ( 0; . + $x)'

# jq -n '[1, [2, [3]]] | [recurse(.[]?) | scalars] | reduce .[] as $x (0; . + $x)' 
# jq -n '[1,2,3] | [repeat(.*2, error)?]'
#echo 1 | jq '[., repeat(if . < 100 then .*2 else error end)?]'

# Factorial via state tuple [n, acc], stopping when n < 1
#echo 4 | jq '[.,1] | until(.[0] < 1; [.[0]-1, .[1]*.[0]]) '

jq -n '5 | [., 1] | until(.[0] < 1; [.[0]-1, .[0] + 1])'
