open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairInstrumentPortPortTransform *)
class type c_listpairinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_listpairinstrumentportporttransform : unit ptr -> c_listpairinstrumentportporttransform_t

module ListPairInstrumentPortPortTransform : sig
  type t = c_listpairinstrumentportporttransform

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> t
  val make : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t
  val items : t -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> int -> int
  val contains : t -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> bool
  val index : t -> Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end