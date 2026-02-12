open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapInstrumentPortPortTransform *)
class type c_mapinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_mapinstrumentportporttransform : unit ptr -> c_mapinstrumentportporttransform_t

module MapInstrumentPortPortTransform : sig
  type t = c_mapinstrumentportporttransform

  val empty : t
  val copy : t -> t
  val make : Pairinstrumentportporttransform.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Instrumentport.t -> Porttransform.t -> unit
  val insert : t -> Instrumentport.t -> Porttransform.t -> unit
  val at : t -> Instrumentport.t -> Porttransform.t
  val erase : t -> Instrumentport.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Instrumentport.t -> bool
  val keys : t -> Listinstrumentport.t
  val values : t -> Listporttransform.t
  val items : t -> Listpairinstrumentportporttransform.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end