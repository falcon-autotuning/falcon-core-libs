open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for AxesLabelledMeasuredArray *)
class type c_axeslabelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_axeslabelledmeasuredarray : unit ptr -> c_axeslabelledmeasuredarray_t

module AxesLabelledMeasuredArray : sig
  type t = c_axeslabelledmeasuredarray

end

module AxesLabelledMeasuredArray : sig
  type t = c_axeslabelledmeasuredarray

  val empty : t
  val copy : t -> t
  val make : ListLabelledMeasuredArray.t -> t
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