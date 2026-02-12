open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesLabelledMeasuredArray *)
class type c_axeslabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_axeslabelledmeasuredarray : unit ptr -> c_axeslabelledmeasuredarray_t

module AxesLabelledMeasuredArray : sig
  type t = c_axeslabelledmeasuredarray

  val empty : t
  val copy : t -> t
  val make : Listlabelledmeasuredarray.t -> t
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