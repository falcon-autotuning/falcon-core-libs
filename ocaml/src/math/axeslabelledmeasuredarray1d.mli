open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesLabelledMeasuredArray1D *)
class type c_axeslabelledmeasuredarray1d_t = object
  method raw : unit ptr
end

class c_axeslabelledmeasuredarray1d : unit ptr -> c_axeslabelledmeasuredarray1d_t

module AxesLabelledMeasuredArray1D : sig
  type t = c_axeslabelledmeasuredarray1d

  val empty : t
  val copy : t -> t
  val make : Listlabelledmeasuredarray1d.ListLabelledMeasuredArray1D.t -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledmeasuredarray1d.LabelledMeasuredArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledmeasuredarray1d.LabelledMeasuredArray1D.t
  val items : t -> Labelledmeasuredarray1d.LabelledMeasuredArray1D.t -> int -> int
  val contains : t -> Labelledmeasuredarray1d.LabelledMeasuredArray1D.t -> bool
  val index : t -> Labelledmeasuredarray1d.LabelledMeasuredArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end