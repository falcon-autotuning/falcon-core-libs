open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for LabelledArraysLabelledControlArray1D *)
class type c_labelledarrayslabelledcontrolarray1d_t = object
  method raw : unit ptr
end

class c_labelledarrayslabelledcontrolarray1d : unit ptr -> c_labelledarrayslabelledcontrolarray1d_t

module LabelledArraysLabelledControlArray1D : sig
  type t = c_labelledarrayslabelledcontrolarray1d

  val make : Listlabelledcontrolarray1d.ListLabelledControlArray1D.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val arrays : t -> Listlabelledcontrolarray1d.ListLabelledControlArray1D.t
  val labels : t -> Listacquisitioncontext.ListAcquisitionContext.t
  val isControlArrays : t -> bool
  val isMeasuredArrays : t -> bool
  val pushBack : t -> Labelledcontrolarray1d.LabelledControlArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledcontrolarray1d.LabelledControlArray1D.t
  val contains : t -> Labelledcontrolarray1d.LabelledControlArray1D.t -> bool
  val index : t -> Labelledcontrolarray1d.LabelledControlArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end