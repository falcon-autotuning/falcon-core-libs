open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for LabelledArraysLabelledControlArray1D *)
class type c_labelledarrayslabelledcontrolarray1d_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledcontrolarray1d : unit ptr -> c_labelledarrayslabelledcontrolarray1d_t

module LabelledArraysLabelledControlArray1D : sig
  type t = c_labelledarrayslabelledcontrolarray1d

end

module LabelledArraysLabelledControlArray1D : sig
  type t = c_labelledarrayslabelledcontrolarray1d

  val make : ListLabelledControlArray1D.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> ListLabelledControlArray1D.t
  val labels : t -> ListAcquisitionContext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> LabelledControlArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledControlArray1D.t
  val contains : t -> LabelledControlArray1D.t -> bool
  val index : t -> LabelledControlArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end