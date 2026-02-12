open Ctypes

open Falcon_core.Communications.Voltage_states
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures

(** Opaque handle for DeviceVoltageStates *)
class type c_devicevoltagestates_t = object
  method raw : unit ptr
end

class c_devicevoltagestates : unit ptr -> c_devicevoltagestates_t

module DeviceVoltageStates : sig
  type t = c_devicevoltagestates

end

module DeviceVoltageStates : sig
  type t = c_devicevoltagestates

  val empty : t
  val make : ListDeviceVoltageState.t -> t
  val fromjson : string -> t
  val states : t -> ListDeviceVoltageState.t
  val addState : t -> DeviceVoltageState.t -> unit
  val findState : t -> Connection.t -> t
  val toPoint : t -> Point.t
  val intersection : t -> t -> t
  val pushBack : t -> DeviceVoltageState.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> DeviceVoltageState.t
  val items : t -> ListDeviceVoltageState.t
  val contains : t -> DeviceVoltageState.t -> bool
  val index : t -> DeviceVoltageState.t -> int
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end