open Ctypes

(** Opaque handle for ListSizeT *)
class type c_listsizet_t = object
  method raw : unit ptr
end

class c_listsizet : unit ptr -> c_listsizet_t

module ListSizeT : sig
  type t = c_listsizet

end

module ListSizeT : sig
  type t = c_listsizet

  val empty : t
  val copy : t -> t
  val allocate : int -> t
  val fillValue : int -> int -> t
  val make : int -> int -> t
  val fromjson : string -> t
  val pushBack : t -> int -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> int
  val items : t -> int -> int -> int
  val contains : t -> int -> bool
  val index : t -> int -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end