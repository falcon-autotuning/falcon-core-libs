open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Instrument_interfaces.Port_transforms

(** Opaque handle for MapInstrumentPortPortTransform *)
class type c_mapinstrumentportporttransform_t = object
  method raw : unit ptr
end

class c_mapinstrumentportporttransform : unit ptr -> c_mapinstrumentportporttransform_t

module MapInstrumentPortPortTransform : sig
  type t = c_mapinstrumentportporttransform

end

module MapInstrumentPortPortTransform : sig
  type t = c_mapinstrumentportporttransform

  val empty : t
  val copy : t -> t
  val make : PairInstrumentPortPortTransform.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> InstrumentPort.t -> PortTransform.t -> unit
  val insert : t -> InstrumentPort.t -> PortTransform.t -> unit
  val at : t -> InstrumentPort.t -> PortTransform.t
  val erase : t -> InstrumentPort.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> InstrumentPort.t -> bool
  val keys : t -> ListInstrumentPort.t
  val values : t -> ListPortTransform.t
  val items : t -> ListPairInstrumentPortPortTransform.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end