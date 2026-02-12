open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairIntInt *)
class type c_listpairintint_t = object
  method raw : unit ptr
end

class c_listpairintint : unit ptr -> c_listpairintint_t

module ListPairIntInt : sig
  type t = c_listpairintint

end

module ListPairIntInt : sig
  type t = c_listpairintint

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairIntInt.t -> t
  val make : PairIntInt.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairIntInt.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairIntInt.t
  val items : t -> PairIntInt.t -> int -> int
  val contains : t -> PairIntInt.t -> bool
  val index : t -> PairIntInt.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end