open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairConnectionFloat *)
class type c_listpairconnectionfloat_t = object
  method raw : unit ptr
end

class c_listpairconnectionfloat : unit ptr -> c_listpairconnectionfloat_t

module ListPairConnectionFloat : sig
  type t = c_listpairconnectionfloat

end

module ListPairConnectionFloat : sig
  type t = c_listpairconnectionfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairConnectionFloat.t -> t
  val make : PairConnectionFloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairConnectionFloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairConnectionFloat.t
  val items : t -> PairConnectionFloat.t -> int -> int
  val contains : t -> PairConnectionFloat.t -> bool
  val index : t -> PairConnectionFloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end