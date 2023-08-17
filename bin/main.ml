(** main entry point *)
open Disc
open Util

(***********************************************************************************)
(* command line arguments                                                          *)
(* see https://dev.realworldocaml.org/command-line-parsing.html                    *)
(***********************************************************************************)



(** print the s-expression parsing of the program (mainly for debugging the parser )*)
let _print_sexp fname =
  (* read the fname into a string *)
  let s = read_whole_file fname in
  let parsed_program = parse_program s in
  Format.printf "%s" (Sexplib0__Sexp.to_string_hum (Syntax.sexp_of_program parsed_program));
  ()

let command =
  Command.basic
    ~summary:"Perform inference an input file"
    ~readme:(fun () -> "")
    (let open Command.Let_syntax in
     let open Command.Param in
     let%map filename = anon ("filename" %: string)
     and inference_type = flag "-i" (required string)
         ~doc:"Inference strategy (one of 'enumerate', 'kc')" in
     fun () ->
        let parsed = parse_from_file filename in
        let internal = Core_grammar.from_external_program parsed in
        let inference_result = match inference_type with
          | "enumerate" -> Enumerate.infer internal
          | "kc" -> Kc.infer internal
          | _ -> failwith "Unknown inference type" in
        Format.printf "Result: %s" (Bignum.to_string_accurate inference_result))

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command
