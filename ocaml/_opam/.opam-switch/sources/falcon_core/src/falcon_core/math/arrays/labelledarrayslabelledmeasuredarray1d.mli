open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for LabelledArraysLabelledMeasuredArray1D *)
class type c_labelledarrayslabelledmeasuredarray1d_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledmeasuredarray1d : unit ptr -> c_labelledarrayslabelledmeasuredarray1d_t

module LabelledArraysLabelledMeasuredArray1D : sig
  type t = c_labelledarrayslabelledmeasuredarray1d

end

module LabelledArraysLabelledMeasuredArray1D : sig
  type t = c_labelledarrayslabelledmeasuredarray1d

  val make : ListLabelledMeasuredArray1D.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> ListLabelledMeasuredArray1D.t
  val labels : t -> ListAcquisitionContext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> LabelledMeasuredArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledMeasuredArray1D.t
  val contains : t -> LabelledMeasuredArray1D.t -> bool
  val index : t -> LabelledMeasuredArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end