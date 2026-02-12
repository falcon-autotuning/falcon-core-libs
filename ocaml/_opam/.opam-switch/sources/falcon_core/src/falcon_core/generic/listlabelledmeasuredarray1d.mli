open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListLabelledMeasuredArray1D *)
class type c_listlabelledmeasuredarray1d_t = object
  method raw : unit ptr
end

class c_listlabelledmeasuredarray1d : unit ptr -> c_listlabelledmeasuredarray1d_t

module ListLabelledMeasuredArray1D : sig
  type t = c_listlabelledmeasuredarray1d

end

module ListLabelledMeasuredArray1D : sig
  type t = c_listlabelledmeasuredarray1d

  val empty : t
  val copy : t -> t
  val fillValue : int -> LabelledMeasuredArray1D.t -> t
  val make : LabelledMeasuredArray1D.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> LabelledMeasuredArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledMeasuredArray1D.t
  val items : t -> LabelledMeasuredArray1D.t -> int -> int
  val contains : t -> LabelledMeasuredArray1D.t -> bool
  val index : t -> LabelledMeasuredArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end