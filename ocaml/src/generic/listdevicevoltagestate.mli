open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListDeviceVoltageState *)
class type c_listdevicevoltagestate_t = object
  method raw : unit ptr
end

class c_listdevicevoltagestate : unit ptr -> c_listdevicevoltagestate_t

module ListDeviceVoltageState : sig
  type t = c_listdevicevoltagestate

  val empty : t
  val copy : t -> t
  val fillValue : int -> Devicevoltagestate.t -> t
  val make : Devicevoltagestate.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Devicevoltagestate.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Devicevoltagestate.t
  val items : t -> Devicevoltagestate.t -> int -> int
  val contains : t -> Devicevoltagestate.t -> bool
  val index : t -> Devicevoltagestate.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end