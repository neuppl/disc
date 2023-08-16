(** describes a generic inference interface *)


(** a generic semiring type over which we will perform inference computations *)
module type Semiring = sig
  type t
  val zero: t
  val one: t
  val plus: t -> t -> t
  val times: t -> t -> t
  val eq: t -> t -> bool
  val less_than: t -> t -> bool
  val greater_than: t -> t -> bool
  val to_string: t -> string
end

module RationalSemiring : Semiring = struct
  type t = Bignum.t
  let zero = Bignum.zero
  let one = Bignum.one
  let plus = Bignum.(+)
  let times = Bignum.( * )
  let eq = Bignum.equal
  let less_than = Bignum.(<)
  let greater_than = Bignum.(>)
  let to_string = Bignum.to_string_accurate
end

module type Inference = functor (S : Semiring) -> sig
  val infer: Core_grammar.program -> S.t
end
