open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesLabelledControlArray *)
class type c_axeslabelledcontrolarray_t = object
  method raw : unit ptr
end

class c_axeslabelledcontrolarray : unit ptr -> c_axeslabelledcontrolarray_t

module AxesLabelledControlArray : sig
  type t = c_axeslabelledcontrolarray

  val empty : t
  val copy : t -> t
  val make : Listlabelledcontrolarray.t -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledcontrolarray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledcontrolarray.t
  val items : t -> Labelledcontrolarray.t -> int -> int
  val contains : t -> Labelledcontrolarray.t -> bool
  val index : t -> Labelledcontrolarray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end