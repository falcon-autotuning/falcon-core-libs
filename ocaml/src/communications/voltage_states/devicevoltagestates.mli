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
  val make : Listdevicevoltagestate.t -> t
  val fromjson : string -> t
  val states : t -> Listdevicevoltagestate.t
  val addState : t -> Devicevoltagestate.t -> unit
  val findState : t -> Connection.t -> t
  val toPoint : t -> Point.t
  val intersection : t -> t -> t
  val pushBack : t -> Devicevoltagestate.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Devicevoltagestate.t
  val items : t -> Listdevicevoltagestate.t
  val contains : t -> Devicevoltagestate.t -> bool
  val index : t -> Devicevoltagestate.t -> int
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end