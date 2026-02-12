open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListLabelledMeasuredArray *)
class type c_listlabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_listlabelledmeasuredarray : unit ptr -> c_listlabelledmeasuredarray_t

module ListLabelledMeasuredArray : sig
  type t = c_listlabelledmeasuredarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> Labelledmeasuredarray.LabelledMeasuredArray.t -> t
  val make : Labelledmeasuredarray.LabelledMeasuredArray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledmeasuredarray.LabelledMeasuredArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledmeasuredarray.LabelledMeasuredArray.t
  val items : t -> Labelledmeasuredarray.LabelledMeasuredArray.t -> int -> int
  val contains : t -> Labelledmeasuredarray.LabelledMeasuredArray.t -> bool
  val index : t -> Labelledmeasuredarray.LabelledMeasuredArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end