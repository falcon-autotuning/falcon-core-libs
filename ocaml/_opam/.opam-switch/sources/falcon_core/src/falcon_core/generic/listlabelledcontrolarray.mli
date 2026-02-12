open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListLabelledControlArray *)
class type c_listlabelledcontrolarray_t = object
  method raw : unit ptr
end

class c_listlabelledcontrolarray : unit ptr -> c_listlabelledcontrolarray_t

module ListLabelledControlArray : sig
  type t = c_listlabelledcontrolarray

end

module ListLabelledControlArray : sig
  type t = c_listlabelledcontrolarray

  val empty : t
  val copy : t -> t
  val fillValue : int -> LabelledControlArray.t -> t
  val make : LabelledControlArray.t -> int -> t
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