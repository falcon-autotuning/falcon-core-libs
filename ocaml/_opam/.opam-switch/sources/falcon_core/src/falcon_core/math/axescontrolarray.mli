open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for AxesControlArray *)
class type c_axescontrolarray_t = object
  method raw : unit ptr
end

class c_axescontrolarray : unit ptr -> c_axescontrolarray_t

module AxesControlArray : sig
  type t = c_axescontrolarray

end

module AxesControlArray : sig
  type t = c_axescontrolarray

  val empty : t
  val copy : t -> t
  val make : ListControlArray.t -> t
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