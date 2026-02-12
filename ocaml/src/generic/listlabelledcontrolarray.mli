open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListLabelledControlArray *)
class type c_listlabelledcontrolarray_t = object
  method raw : unit ptr
end

class c_listlabelledcontrolarray : unit ptr -> c_listlabelledcontrolarray_t

module ListLabelledControlArray : sig
  type t = c_listlabelledcontrolarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> Labelledcontrolarray.LabelledControlArray.t -> t
  val make : Labelledcontrolarray.LabelledControlArray.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Labelledcontrolarray.LabelledControlArray.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelledcontrolarray.LabelledControlArray.t
  val items : t -> Labelledcontrolarray.LabelledControlArray.t -> int -> int
  val contains : t -> Labelledcontrolarray.LabelledControlArray.t -> bool
  val index : t -> Labelledcontrolarray.LabelledControlArray.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end