def double: . * 2;
def titlecase_prelim: split(" ") | map(.[0:1]) | join(" ");
def titlecase2: 
  split(" ") | 
  map((.[0:1]|ascii_upcase) + .[1:]) | 
  join(" ");
