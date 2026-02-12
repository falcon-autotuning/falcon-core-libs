open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for AxesControlArray1D *)
class type c_axescontrolarray1d_t = object
  method raw : unit ptr
end

class c_axescontrolarray1d : unit ptr -> c_axescontrolarray1d_t

module AxesControlArray1D : sig
  type t = c_axescontrolarray1d

end

module AxesControlArray1D : sig
  type t = c_axescontrolarray1d

  val empty : t
  val copy : t -> t
  val make : ListControlArray1D.t -> t
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