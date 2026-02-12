open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for LabelledArraysLabelledMeasuredArray *)
class type c_labelledarrayslabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledmeasuredarray : unit ptr -> c_labelledarrayslabelledmeasuredarray_t

module LabelledArraysLabelledMeasuredArray : sig
  type t = c_labelledarrayslabelledmeasuredarray

  val make : Listlabelledmeasuredarray.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> Listlabelledmeasuredarray.t
  val labels : t -> Listacquisitioncontext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> Labelledmeasuredarray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledmeasuredarray.t
  val contains : t -> Labelledmeasuredarray.t -> bool
  val index : t -> Labelledmeasuredarray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end