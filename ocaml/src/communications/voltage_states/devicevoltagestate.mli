open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for DeviceVoltageState *)
class type c_devicevoltagestate_t = object
  method raw : unit ptr
end

class c_devicevoltagestate : unit ptr -> c_devicevoltagestate_t

module DeviceVoltageState : sig
  type t = c_devicevoltagestate

  val make : Connection.Connection.t -> float -> Symbolunit.SymbolUnit.t -> t
  val fromjson : string -> t
  val connection : t -> Connection.Connection.t
  val voltage : t -> float
  val value : t -> float
  val unit : t -> Symbolunit.SymbolUnit.t
  val convertTo : t -> Symbolunit.SymbolUnit.t -> unit
  val multiplyInt : t -> int -> t
  val multiplyDouble : t -> float -> t
  val multiplyQuantity : t -> t -> t
  val multiplyEqualsInt : t -> int -> t
  val multiplyEqualsDouble : t -> float -> t
  val multiplyEqualsQuantity : t -> t -> t
  val divideInt : t -> int -> t
  val divideDouble : t -> float -> t
  val divideQuantity : t -> t -> t
  val divideEqualsInt : t -> int -> t
  val divideEqualsDouble : t -> float -> t
  val divideEqualsQuantity : t -> t -> t
  val power : t -> int -> t
  val addQuantity : t -> t -> t
  val addEqualsQuantity : t -> t -> t
  val subtractQuantity : t -> t -> t
  val subtractEqualsQuantity : t -> t -> t
  val negate : t -> t
  val abs : t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end