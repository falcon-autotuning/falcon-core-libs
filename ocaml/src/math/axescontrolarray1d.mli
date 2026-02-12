open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesControlArray1D *)
class type c_axescontrolarray1d_t = object
  method raw : unit ptr
end

class c_axescontrolarray1d : unit ptr -> c_axescontrolarray1d_t

module AxesControlArray1D : sig
  type t = c_axescontrolarray1d

  val empty : t
  val copy : t -> t
  val make : Listcontrolarray1d.t -> t
  val fromjson : string -> t
  val pushBack : t -> Controlarray1d.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Controlarray1d.t
  val items : t -> Controlarray1d.t -> int -> int
  val contains : t -> Controlarray1d.t -> bool
  val index : t -> Controlarray1d.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end