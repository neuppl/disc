(** inference via knowledge compilation *)

open Rsdd

let () =
  let robdd_builder = mk_bdd_builder_default_order 6L in
    let bdd = bdd_builder_compile_cnf robdd_builder (cnf_from_dimacs "
    p cnf 6 3\n\
    1 2 3 4 0\n\
    -2 -3 4 5 0\n\
    -4 -5 6 6 0\n\
    ") in
    let model_count = bdd_model_count robdd_builder bdd in
    print_endline (Int64.to_string model_count)


let infer _prog = failwith "todo"
