open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairConnectionFloat *)
class type c_listpairconnectionfloat_t = object
  method raw : unit ptr
end

class c_listpairconnectionfloat : unit ptr -> c_listpairconnectionfloat_t

module ListPairConnectionFloat : sig
  type t = c_listpairconnectionfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairconnectionfloat.t -> t
  val make : Pairconnectionfloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairconnectionfloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairconnectionfloat.t
  val items : t -> Pairconnectionfloat.t -> int -> int
  val contains : t -> Pairconnectionfloat.t -> bool
  val index : t -> Pairconnectionfloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end