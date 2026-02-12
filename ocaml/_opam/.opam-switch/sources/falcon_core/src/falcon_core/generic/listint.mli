open Ctypes

(** Opaque handle for ListInt *)
class type c_listint_t = object
  method raw : unit ptr
end

class c_listint : unit ptr -> c_listint_t

module ListInt : sig
  type t = c_listint

end

module ListInt : sig
  type t = c_listint

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