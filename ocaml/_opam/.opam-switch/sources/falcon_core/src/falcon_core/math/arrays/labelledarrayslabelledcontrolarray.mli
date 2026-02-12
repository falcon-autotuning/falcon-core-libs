open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for LabelledArraysLabelledControlArray *)
class type c_labelledarrayslabelledcontrolarray_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledcontrolarray : unit ptr -> c_labelledarrayslabelledcontrolarray_t

module LabelledArraysLabelledControlArray : sig
  type t = c_labelledarrayslabelledcontrolarray

end

module LabelledArraysLabelledControlArray : sig
  type t = c_labelledarrayslabelledcontrolarray

  val make : ListLabelledControlArray.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> ListLabelledControlArray.t
  val labels : t -> ListAcquisitionContext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> LabelledControlArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledControlArray.t
  val contains : t -> LabelledControlArray.t -> bool
  val index : t -> LabelledControlArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end