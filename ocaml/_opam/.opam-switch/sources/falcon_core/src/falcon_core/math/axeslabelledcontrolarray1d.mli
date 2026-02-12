open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Arrays

(** Opaque handle for AxesLabelledControlArray1D *)
class type c_axeslabelledcontrolarray1d_t = object
  method raw : unit ptr
end

class c_axeslabelledcontrolarray1d : unit ptr -> c_axeslabelledcontrolarray1d_t

module AxesLabelledControlArray1D : sig
  type t = c_axeslabelledcontrolarray1d

end

module AxesLabelledControlArray1D : sig
  type t = c_axeslabelledcontrolarray1d

  val empty : t
  val copy : t -> t
  val make : ListLabelledControlArray1D.t -> t
  val fromjson : string -> t
  val pushBack : t -> LabelledControlArray1D.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledControlArray1D.t
  val items : t -> LabelledControlArray1D.t -> int -> int
  val contains : t -> LabelledControlArray1D.t -> bool
  val index : t -> LabelledControlArray1D.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end