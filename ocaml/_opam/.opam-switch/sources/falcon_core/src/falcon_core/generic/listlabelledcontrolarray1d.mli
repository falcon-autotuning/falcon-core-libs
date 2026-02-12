open Ctypes

open Falcon_core.Math.Arrays

(** Opaque handle for ListLabelledControlArray1D *)
class type c_listlabelledcontrolarray1d_t = object
  method raw : unit ptr
end

class c_listlabelledcontrolarray1d : unit ptr -> c_listlabelledcontrolarray1d_t

module ListLabelledControlArray1D : sig
  type t = c_listlabelledcontrolarray1d

end

module ListLabelledControlArray1D : sig
  type t = c_listlabelledcontrolarray1d

  val empty : t
  val copy : t -> t
  val fillValue : int -> LabelledControlArray1D.t -> t
  val make : LabelledControlArray1D.t -> int -> t
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