open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairConnectionDouble *)
class type c_listpairconnectiondouble_t = object
  method raw : unit ptr
end

class c_listpairconnectiondouble : unit ptr -> c_listpairconnectiondouble_t

module ListPairConnectionDouble : sig
  type t = c_listpairconnectiondouble

end

module ListPairConnectionDouble : sig
  type t = c_listpairconnectiondouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairConnectionDouble.t -> t
  val make : PairConnectionDouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairConnectionDouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairConnectionDouble.t
  val items : t -> PairConnectionDouble.t -> int -> int
  val contains : t -> PairConnectionDouble.t -> bool
  val index : t -> PairConnectionDouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end