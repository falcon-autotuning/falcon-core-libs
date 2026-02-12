open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for DeviceVoltageStates *)
class type c_devicevoltagestates_t = object
  method raw : unit ptr
end

class c_devicevoltagestates : unit ptr -> c_devicevoltagestates_t

module DeviceVoltageStates : sig
  type t = c_devicevoltagestates

  val empty : t
  val make : Listdevicevoltagestate.ListDeviceVoltageState.t -> t
  val fromjson : string -> t
  val states : t -> Listdevicevoltagestate.ListDeviceVoltageState.t
  val addState : t -> Devicevoltagestate.DeviceVoltageState.t -> unit
  val findState : t -> Connection.Connection.t -> t
  val toPoint : t -> Point.Point.t
  val intersection : t -> t -> t
  val pushBack : t -> Devicevoltagestate.DeviceVoltageState.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Devicevoltagestate.DeviceVoltageState.t
  val items : t -> Listdevicevoltagestate.ListDeviceVoltageState.t
  val contains : t -> Devicevoltagestate.DeviceVoltageState.t -> bool
  val index : t -> Devicevoltagestate.DeviceVoltageState.t -> int
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end