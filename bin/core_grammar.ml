(** Contains the internal core grammar for the discrete language *)
open Bignum

type eexpr =
    And        of eexpr * eexpr
  | Or         of eexpr * eexpr
  | Not        of eexpr
  | Ite        of eexpr * eexpr * eexpr
  | Flip       of Bignum.t
  | Bind       of string * eexpr * eexpr
  | Observe    of eexpr
  | Ident      of string
  | Tup        of eexpr * eexpr
  | Fst        of eexpr
  | Snd        of eexpr
  | True
  | False
[@@deriving sexp_of]


(** top-level symbol *)
type program = { body: eexpr }
[@@deriving sexp_of]
