(** main entry point *)

open Lexing

let colnum pos =
  (pos.pos_cnum - pos.pos_bol) - 1

let pos_string pos =
  let l = string_of_int pos.pos_lnum
  and c = string_of_int ((colnum pos) + 1) in
  "line " ^ l ^ ", column " ^ c

let parse' f s =
  let lexbuf = Lexing.from_string s in
  try
    f Lexer.token lexbuf
  with Parser.Error ->
    raise (Failure ("Parse error at " ^ (pos_string lexbuf.lex_curr_p)))

(** parse a string into program syntax *)
let parse_program s =
  parse' Parser.program s

(** read `filename` into a string *)
let read_whole_file filename =
  (* open_in_bin works correctly on Unix and Windows *)
  let ch = open_in_bin filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

(** parse a program from a filename into an AST *)
let parse_from_file filename =
  read_whole_file filename
  |> parse_program

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
