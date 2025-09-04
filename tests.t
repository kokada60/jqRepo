include "testlib1"; double 
5
10

include "testlib1"; map(.name |= titlecase2 | .yrs |= double) | sort_by(.name)
[{ "name":"washoe county school district", "yrs": 5 }, { "name":"clark county school district", "yrs": 10 }]
[{ "name":"Clark County School District", "yrs": 20 }, { "name":"Washoe County School District", "yrs": 10 }]

# Group an json array, gather an attribute into an array within the group... Sort the output by group key... 
group_by(.role) | map({role: .[0].role, "name": map(.name) | sort_by(.)}) | sort_by(.role)
[{"name":"Katee the admin", "role":"admin"},{"name":"Kzy the admin","role":"admin"},{"name":"Kim the staff","role":"staff"},{"name":"Kai the staff","role":"staff"},{"name":"Kiera the admin", "role":"admin"}]
[{"role":"admin","name":["Katee the admin","Kiera the admin","Kzy the admin"]},{"role":"staff","name":["Kai the staff","Kim the staff"]}]

# # built a module to perform the transformation. Verifying by stage...
include "testlib1"; group_by_key_module("role"; "name")
[{"name":"Katee the admin", "role":"admin"},{"name":"Kzy the admin","role":"admin"},{"name":"Kim the staff","role":"staff"},{"name":"Kai the staff","role":"staff"},{"name":"Kiera the admin", "role":"admin"}]
[{"role":"admin","name":["Katee the admin","Kiera the admin","Kzy the admin"]},{"role":"staff","name":["Kai the staff","Kim the staff"]}]

## testing a module function that allows filter to be passed in as a parameter 
include "testlib1"; update_field("yrs"; . * 3)
{"name":"clark county","yrs":5}
{"name":"clark county","yrs":15}

## testing a module function that allows filter to be passed in as a parameter 
include "testlib1"; update_field("name"; . + " test")
{"name":"clark county","yrs":5}
{"name":"clark county test","yrs":5}

