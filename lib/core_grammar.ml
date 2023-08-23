(** Contains the internal core grammar for the discrete language *)
open Sexplib.Std

(** core grammar type *)
type expr =
    And        of expr * expr
  | Or         of expr * expr
  | Not        of expr
  | Ite        of expr * expr * expr
  | Flip       of Bignum.t
  | Bind       of string * expr * expr
  | Observe    of expr * expr
  | Ident      of string
  | Return     of expr
  | True
  | False
[@@deriving sexp_of]

(* Substituting string i in expr e with expr f *)
let rec subst (e : expr) (f : expr) (i : string) : expr = match e with
  | Ident(s)          -> if s = i then f else Ident(s)
  (* The rest are super easy recursion *)
  | And(e1, e2)       -> And(subst e1 f i, subst e2 f i)
  | Or(e1, e2)        -> Or(subst e1 f i, subst e2 f i)
  | Not(e1)           -> Not(subst e1 f i)
  | Ite(guard, t, e') -> Ite(subst guard f i, subst t f i, subst e' f i)
  | Bind(s, e1, e2)   -> 
    if s == i then failwith "BindingError: Conflicting variable names!"
    else Bind(s, subst e1 f i, subst e2 f i)
  | Observe(e1, e2)         -> Observe((subst e1 f i), (subst e2 f i))
  | Return e          -> Return (subst e f i)
  | x                 -> x  

(** top-level symbol *)
type program = { body: expr }
[@@deriving sexp_of]

(** convert an expression in the external grammar into one in the internal grammar *)
let rec from_external_expr (e: Syntax.eexpr) =
  let f = from_external_expr in
  match e with
  | And(_, e1, e2)      -> And(f e1, f e2)
  | Or(_, e1, e2)       -> Or(f e1, f e2)
  | Not(_, e)           -> Not(f e)
  | Ite(_, g, thn, els) -> Ite(f g, f thn, f els)
  | Flip(_, n)          -> Flip(n)
  | Observe(_, e, e')       -> Observe(f e, f e')
  | Return(_, e)        -> Return(f e)
  | Bind(_, x, e1, e2)  -> Bind(x, f e1, f e2)
  | Ident(_, x)         -> Ident(x)
  | True _              -> True
  | False _             -> False

(** convert an external program into a core program *)
let from_external_program (e: Syntax.program) = { body = (from_external_expr e.body) }
