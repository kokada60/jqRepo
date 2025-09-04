def greet($k): {msg: "hello " + (.[$k] // "world")}; greet("name")
{"name":"Ken"}
{"msg":"hello Ken"}