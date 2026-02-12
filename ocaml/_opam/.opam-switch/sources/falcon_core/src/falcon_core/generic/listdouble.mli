open Ctypes

(** Opaque handle for ListDouble *)
class type c_listdouble_t = object
  method raw : unit ptr
end

class c_listdouble : unit ptr -> c_listdouble_t

module ListDouble : sig
  type t = c_listdouble

end

module ListDouble : sig
  type t = c_listdouble

  val empty : t
  val copy : t -> t
  val allocate : int -> t
  val fillValue : int -> float -> t
  val make : float -> int -> t
  val fromjson : string -> t
  val pushBack : t -> float -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> float
  val items : t -> float -> int -> int
  val contains : t -> float -> bool
  val index : t -> float -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end