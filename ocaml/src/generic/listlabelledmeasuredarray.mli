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
  val fillValue : int -> Labelledmeasuredarray.t -> t
  val make : Labelledmeasuredarray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledmeasuredarray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledmeasuredarray.t
  val items : t -> Labelledmeasuredarray.t -> int -> int
  val contains : t -> Labelledmeasuredarray.t -> bool
  val index : t -> Labelledmeasuredarray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end