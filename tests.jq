# try suppresses error
try (.b + 1)
{"a":1}
# (no outputs)
 
# catch customizes the error
try (.b + 1) catch ("ERR: " + .)
{"a":1}
"ERR: Cannot index object with string \"b\""

# custom error and catch
try (if .role=="admin" then "ok" else error({code:"AUTHZ"}) end)
catch (if .code?=="AUTHZ" then "fallback" else . end)
{"role":"guest"}
"fallback"