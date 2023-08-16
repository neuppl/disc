(** manages all BDD operations *)
type manager

(** a BDD pointer *)
type bddptr

(** variable label *)
type label

(** make a new BDD manager with a linear order (variables ordered numerically by
    their label) *)
val mk_bdd_manager_default_order : int -> manager

(** `bdd_newvar: manager -> polarity -> bddptr`
     make a new variable at the end of the order with polarity `polarity` *)
val bdd_newvar : manager -> bool -> bddptr

(** `bdd_ite: manager -> f -> g -> h -> result`
     Returns the BDD that results from `if f then g else h` *)
val bdd_ite : manager -> bddptr -> bddptr -> bddptr -> bddptr
val bdd_and : manager -> bddptr -> bddptr -> bddptr
val bdd_or : manager -> bddptr -> bddptr -> bddptr
val bdd_negate : manager -> bddptr -> bddptr

(** true if `bddptr` is the constant True *)
val bdd_is_true : manager -> bddptr -> bool

(** true if `bddptr` is the constant False *)
val bdd_is_false : manager -> bddptr -> bool

(** produce a constant True *)
val bdd_true : manager -> bddptr

(** produce a constant False *)
val bdd_false : manager -> bddptr

(** get the top variable in the BDD *)
val bdd_topvar : manager -> bddptr -> label

(** true if the BDD is a constant (True or False) *)
val bdd_is_const : manager -> bddptr -> bool

(** check if two BDDs are logically equivalent *)
val bdd_eq : manager -> bddptr -> bddptr -> bool

(** get the low pointer for a BDD *)
val bdd_low : manager -> bddptr -> bddptr

(** get the high pointer for a BDD *)
val bdd_high : manager -> bddptr -> bddptr

module type Wmc = functor (S : Semiring.Semiring) -> sig
  type weight = { low: S.t; high: S.t }
  type weight_array = weight Array.t
  val wmc : manager -> bddptr -> weight_array -> S.t
end

