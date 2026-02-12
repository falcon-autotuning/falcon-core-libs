open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesLabelledControlArray1D *)
class type c_axeslabelledcontrolarray1d_t = object
  method raw : unit ptr
end

class c_axeslabelledcontrolarray1d : unit ptr -> c_axeslabelledcontrolarray1d_t

module AxesLabelledControlArray1D : sig
  type t = c_axeslabelledcontrolarray1d

  val empty : t
  val copy : t -> t
  val make : Listlabelledcontrolarray1d.t -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledcontrolarray1d.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledcontrolarray1d.t
  val items : t -> Labelledcontrolarray1d.t -> int -> int
  val contains : t -> Labelledcontrolarray1d.t -> bool
  val index : t -> Labelledcontrolarray1d.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end