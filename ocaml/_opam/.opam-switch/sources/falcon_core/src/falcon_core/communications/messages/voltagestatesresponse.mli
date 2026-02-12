open Ctypes

open Falcon_core.Communications.Voltage_states

(** Opaque handle for VoltageStatesResponse *)
class type c_voltagestatesresponse_t = object
  method raw : unit ptr
end

class c_voltagestatesresponse : unit ptr -> c_voltagestatesresponse_t

module VoltageStatesResponse : sig
  type t = c_voltagestatesresponse

end

module VoltageStatesResponse : sig
  type t = c_voltagestatesresponse

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> DeviceVoltageStates.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val message : t -> string
  val states : t -> DeviceVoltageStates.t
end