def greet($k): {msg: ("hello " + (.[$k] // "world"))}; greet("name")
{"name":"Ken"}
{"msg":"hello Ken"}

def check_key($k): . | (has($k)); map( . | check_key("age"))
[{"age":25}, {"name":"testnane", "age": 18},{"name":"justname"}]
[true,true,false]

def check_value($k; $v): if (has($k)) then ( (.[$k]) == $v ) else (false) end; check_value("age"; 25)
{"age":25}
false