open Lexing

(* type inference_strategy = *)
(*   | Enumerate *)
(*   | DirectSampling *)
(*   | KnowledgeCompilation *)

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

(* command line arguments *)

let read_whole_file filename =
  (* open_in_bin works correctly on Unix and Windows *)
  let ch = open_in_bin filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s


let inference fname =
  (* read the fname into a string *)
  let s = read_whole_file fname in
  let parsed_program = parse_program s in
  Format.printf "%s" (Sexplib0__Sexp.to_string_hum (Syntax.sexp_of_program parsed_program));
  ()

let filename_param =
  let open Command.Param in
  anon ("filename" %: string)

let command =
  Command.basic
    ~summary:"Perform inference an input file"
    ~readme:(fun () -> "")
    (Command.Param.map filename_param ~f:(fun filename () ->
         inference filename))

let () = Command_unix.run ~version:"1.0" ~build_info:"RWO" command
