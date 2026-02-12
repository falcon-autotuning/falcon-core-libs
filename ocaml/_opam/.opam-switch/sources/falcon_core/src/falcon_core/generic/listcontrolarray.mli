open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListControlArray *)
class type c_listcontrolarray_t = object
  method raw : unit ptr
end

class c_listcontrolarray : unit ptr -> c_listcontrolarray_t

module ListControlArray : sig
  type t = c_listcontrolarray

end

module ListControlArray : sig
  type t = c_listcontrolarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> ControlArray.t -> t
  val make : ControlArray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> ControlArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> ControlArray.t
  val items : t -> ControlArray.t -> int -> int
  val contains : t -> ControlArray.t -> bool
  val index : t -> ControlArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end