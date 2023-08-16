(** describes a generic inference interface *)


module type Inference = functor (S : Semiring) -> sig
  val infer: Core_grammar.program -> S.t
end
