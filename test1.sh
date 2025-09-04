read -r -d '' json11 <<EOF
[
    {"id": 1, "name": "Ken", "role": "manager", "dob": "2017-01-01"},
    {"id": 2, "name": "Kenneth", "role": "developer", "dob": "2012-06-07"},
    {"id": 3, "name": "Kenni", "role": "vice-president", "dob": "2014-11-20"}, 
    {"id": 4, "name": "Kenny", "role": "director", "dob": "2001-02-27"}, 
    {"id": 5, "name": "Kenyon", "role": "manager", "dob": "2005-09-15", "b": 100}
]
EOF

read -r -d '' json12 <<EOF
[
    {"id": 1, "name": "Ken", "role": ["multi-role", "manager"], "dob": "2017-01-01"},
    {"id": 2, "name": "Kenneth", "role": ["data specialist", "developer"], "dob": "2012-06-07"},
    {"id": 3, "name": "Kenni", "role": ["vice-president"], "dob": "2014-11-20"}, 
    {"id": 4, "name": "Kenny", "role": ["director"], "dob": "2001-02-27"}, 
    {"id": 5, "name": "Kenyon", "role": ["identity manager", "manager"], "dob": "2005-09-15", "b": 100}
]
EOF

read -r -d '' json13 <<EOF
[
    {"id": 1, "x": 10}, 
    {
        "id": 2.5, 
        "x": null
    },
    {"id": 2}, 
    {"id": 3, "x": 0}
]
EOF
