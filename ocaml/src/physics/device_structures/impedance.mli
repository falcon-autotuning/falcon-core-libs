open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Impedance *)
class type c_impedance_t = object
  method raw : unit ptr
end

class c_impedance : unit ptr -> c_impedance_t

module Impedance : sig
  type t = c_impedance

  val copy : t -> t
  val fromjson : string -> t
  val make : Connection.t -> float -> float -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val connection : t -> Connection.t
  val resistance : t -> float
  val capacitance : t -> float
end