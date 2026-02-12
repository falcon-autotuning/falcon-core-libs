open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListLabelledMeasuredArray *)
class type c_listlabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_listlabelledmeasuredarray : unit ptr -> c_listlabelledmeasuredarray_t

module ListLabelledMeasuredArray : sig
  type t = c_listlabelledmeasuredarray

end

module ListLabelledMeasuredArray : sig
  type t = c_listlabelledmeasuredarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> LabelledMeasuredArray.t -> t
  val make : LabelledMeasuredArray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> LabelledMeasuredArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledMeasuredArray.t
  val items : t -> LabelledMeasuredArray.t -> int -> int
  val contains : t -> LabelledMeasuredArray.t -> bool
  val index : t -> LabelledMeasuredArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end