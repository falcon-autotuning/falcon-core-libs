open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairInstrumentPortPortTransform *)
class type c_listpairinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_listpairinstrumentportporttransform : unit ptr -> c_listpairinstrumentportporttransform_t

module ListPairInstrumentPortPortTransform : sig
  type t = c_listpairinstrumentportporttransform

end

module ListPairInstrumentPortPortTransform : sig
  type t = c_listpairinstrumentportporttransform

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairInstrumentPortPortTransform.t -> t
  val make : PairInstrumentPortPortTransform.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairInstrumentPortPortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairInstrumentPortPortTransform.t
  val items : t -> PairInstrumentPortPortTransform.t -> int -> int
  val contains : t -> PairInstrumentPortPortTransform.t -> bool
  val index : t -> PairInstrumentPortPortTransform.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end