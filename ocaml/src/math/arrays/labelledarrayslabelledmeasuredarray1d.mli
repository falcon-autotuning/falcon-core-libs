open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for LabelledArraysLabelledMeasuredArray1D *)
class type c_labelledarrayslabelledmeasuredarray1d_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledmeasuredarray1d : unit ptr -> c_labelledarrayslabelledmeasuredarray1d_t

module LabelledArraysLabelledMeasuredArray1D : sig
  type t = c_labelledarrayslabelledmeasuredarray1d

  val make : Listlabelledmeasuredarray1d.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> Listlabelledmeasuredarray1d.t
  val labels : t -> Listacquisitioncontext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> Labelledmeasuredarray1d.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledmeasuredarray1d.t
  val contains : t -> Labelledmeasuredarray1d.t -> bool
  val index : t -> Labelledmeasuredarray1d.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end