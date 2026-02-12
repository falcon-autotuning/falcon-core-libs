open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListControlArray *)
class type c_listcontrolarray_t = object
  method raw : unit ptr
end

class c_listcontrolarray : unit ptr -> c_listcontrolarray_t

module ListControlArray : sig
  type t = c_listcontrolarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> Controlarray.ControlArray.t -> t
  val make : Controlarray.ControlArray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Controlarray.ControlArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Controlarray.ControlArray.t
  val items : t -> Controlarray.ControlArray.t -> int -> int
  val contains : t -> Controlarray.ControlArray.t -> bool
  val index : t -> Controlarray.ControlArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end