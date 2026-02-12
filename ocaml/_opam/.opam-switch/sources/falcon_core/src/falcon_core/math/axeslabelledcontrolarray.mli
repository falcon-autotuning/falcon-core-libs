open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for AxesLabelledControlArray *)
class type c_axeslabelledcontrolarray_t = object
  method raw : unit ptr
end

class c_axeslabelledcontrolarray : unit ptr -> c_axeslabelledcontrolarray_t

module AxesLabelledControlArray : sig
  type t = c_axeslabelledcontrolarray

end

module AxesLabelledControlArray : sig
  type t = c_axeslabelledcontrolarray

  val empty : t
  val copy : t -> t
  val make : ListLabelledControlArray.t -> t
  val fromjson : string -> t
  val pushBack : t -> LabelledControlArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledControlArray.t
  val items : t -> LabelledControlArray.t -> int -> int
  val contains : t -> LabelledControlArray.t -> bool
  val index : t -> LabelledControlArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end