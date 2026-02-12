open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairStringDouble *)
class type c_listpairstringdouble_t = object
  method raw : unit ptr
end

class c_listpairstringdouble : unit ptr -> c_listpairstringdouble_t

module ListPairStringDouble : sig
  type t = c_listpairstringdouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairstringdouble.t -> t
  val make : Pairstringdouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairstringdouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairstringdouble.t
  val items : t -> Pairstringdouble.t -> int -> int
  val contains : t -> Pairstringdouble.t -> bool
  val index : t -> Pairstringdouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end