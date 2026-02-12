open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for LabelledArraysLabelledMeasuredArray *)
class type c_labelledarrayslabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledmeasuredarray : unit ptr -> c_labelledarrayslabelledmeasuredarray_t

module LabelledArraysLabelledMeasuredArray : sig
  type t = c_labelledarrayslabelledmeasuredarray

end

module LabelledArraysLabelledMeasuredArray : sig
  type t = c_labelledarrayslabelledmeasuredarray

  val make : ListLabelledMeasuredArray.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> ListLabelledMeasuredArray.t
  val labels : t -> ListAcquisitionContext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> LabelledMeasuredArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledMeasuredArray.t
  val contains : t -> LabelledMeasuredArray.t -> bool
  val index : t -> LabelledMeasuredArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end