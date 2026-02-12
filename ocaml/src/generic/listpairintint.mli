open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairIntInt *)
class type c_listpairintint_t = object
  method raw : unit ptr
end

class c_listpairintint : unit ptr -> c_listpairintint_t

module ListPairIntInt : sig
  type t = c_listpairintint

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairintint.PairIntInt.t -> t
  val make : Pairintint.PairIntInt.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairintint.PairIntInt.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairintint.PairIntInt.t
  val items : t -> Pairintint.PairIntInt.t -> int -> int
  val contains : t -> Pairintint.PairIntInt.t -> bool
  val index : t -> Pairintint.PairIntInt.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end