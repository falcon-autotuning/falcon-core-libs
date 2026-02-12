open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListControlArray1D *)
class type c_listcontrolarray1d_t = object
  method raw : unit ptr
end

class c_listcontrolarray1d : unit ptr -> c_listcontrolarray1d_t

module ListControlArray1D : sig
  type t = c_listcontrolarray1d

end

module ListControlArray1D : sig
  type t = c_listcontrolarray1d

  val empty : t
  val copy : t -> t
  val fillValue : int -> ControlArray1D.t -> t
  val make : ControlArray1D.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> ControlArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> ControlArray1D.t
  val items : t -> ControlArray1D.t -> int -> int
  val contains : t -> ControlArray1D.t -> bool
  val index : t -> ControlArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end