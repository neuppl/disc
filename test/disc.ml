(** https://dev.realworldocaml.org/testing.html *)

open OUnit2
open Disc

(** given an input string s, give an importance estimate that results from drawing n 
    samples *)
let enumerate_program (s : string) = 
  let parsed = Util.parse_program s in
  let internal = Core_grammar.from_external_program parsed in
  Enumerate.infer internal
let kc_program (s : string) = 
  let parsed = Util.parse_program s in
  let internal = Core_grammar.from_external_program parsed in
  Kc.infer internal

let prog1 = "
  x <- flip 0.5 ; return x
"

let prog1' = "
  x <- flip 0.5 ; return (!x)
"

let prog2 = "
  x <- flip 0.5; 
  y <- flip 0.7;
  return x
"

let prog_and = "
x <- flip 0.5;
y <- flip 0.7;
return (x && y)
"

let prog_or = "
x <- flip 0.5;
y <- flip 0.7;
return (x || y)
"

let prog_ite = "
x <- flip 0.5;
y <- if x then flip 0.5 else flip 0.7;
return y
"

let prog_obs = "
x <- flip 0.6; 
y <- flip 0.3;
observe x || y;
return x
"

let prog_mixed =  "
x <- flip 0.7;
y <- if x then flip 0.5 else flip 0.3;
observe y;
return x
"

let within_epsilon a b = Float.abs(Bignum.to_float a -. Bignum.to_float b) < 0.01

let cmp_val (s : string) = 
  let v = enumerate_program s in 
  let w = kc_program s in 
  let b = if Bignum.equal v w then true else within_epsilon v w in 
  assert_bool ("bruh, we failed a test.") b

let tests = "testing" >::: [
  "basic" >:: (fun _ -> cmp_val prog1);
  "basic2" >:: (fun _ -> cmp_val prog1');
  "ig" >:: (fun _ -> cmp_val prog2);
  "and" >:: (fun _ -> cmp_val prog_and);
  "or" >:: (fun _ -> cmp_val prog_or);
  "ite" >:: (fun _ -> cmp_val prog_ite);
  "observe" >:: (fun _ -> cmp_val prog_obs);
  "mixed" >:: (fun _ -> cmp_val prog_mixed)
]

let _ = Random.self_init ()
let _ = run_test_tt_main tests