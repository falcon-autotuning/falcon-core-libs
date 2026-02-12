open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesControlArray *)
class type c_axescontrolarray_t = object
  method raw : unit ptr
end

class c_axescontrolarray : unit ptr -> c_axescontrolarray_t

module AxesControlArray : sig
  type t = c_axescontrolarray

  val empty : t
  val copy : t -> t
  val make : Listcontrolarray.ListControlArray.t -> t
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