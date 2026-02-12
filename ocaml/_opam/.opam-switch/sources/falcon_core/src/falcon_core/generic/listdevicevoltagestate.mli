open Ctypes

open Falcon_core.Communications.Voltage_states

(** Opaque handle for ListDeviceVoltageState *)
class type c_listdevicevoltagestate_t = object
  method raw : unit ptr
end

class c_listdevicevoltagestate : unit ptr -> c_listdevicevoltagestate_t

module ListDeviceVoltageState : sig
  type t = c_listdevicevoltagestate

end

module ListDeviceVoltageState : sig
  type t = c_listdevicevoltagestate

  val empty : t
  val copy : t -> t
  val fillValue : int -> DeviceVoltageState.t -> t
  val make : DeviceVoltageState.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> DeviceVoltageState.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> DeviceVoltageState.t
  val items : t -> DeviceVoltageState.t -> int -> int
  val contains : t -> DeviceVoltageState.t -> bool
  val index : t -> DeviceVoltageState.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end