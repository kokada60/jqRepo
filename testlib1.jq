def double: . * 2;
def titlecase_prelim: split(" ") | map(.[0:1]) | join(" ");
def titlecase2: 
  split(" ") | 
  map((.[0:1]|ascii_upcase) + .[1:]) | 
  join(" ");
def greet($k): {msg: ("hello " + (.[$k] // "world"))};
def group_by_key_module($k; $g):
  group_by(.[$k])
  | .
  | map({
      ($k): getpath([0, ($k)]),
      ($g): (map(.[$g]) | sort_by(.))
    })
  | sort_by(.[$k]);
 def update_field($k; f):
  .[($k)] |= (. | f);