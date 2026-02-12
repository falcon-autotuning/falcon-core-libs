open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairConnectionDouble *)
class type c_listpairconnectiondouble_t = object
  method raw : unit ptr
end

class c_listpairconnectiondouble : unit ptr -> c_listpairconnectiondouble_t

module ListPairConnectionDouble : sig
  type t = c_listpairconnectiondouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairconnectiondouble.t -> t
  val make : Pairconnectiondouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairconnectiondouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairconnectiondouble.t
  val items : t -> Pairconnectiondouble.t -> int -> int
  val contains : t -> Pairconnectiondouble.t -> bool
  val index : t -> Pairconnectiondouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end