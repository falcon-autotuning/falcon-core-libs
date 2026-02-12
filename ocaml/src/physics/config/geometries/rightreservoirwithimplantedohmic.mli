open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for RightReservoirWithImplantedOhmic *)
class type c_rightreservoirwithimplantedohmic_t = object
  method raw : unit ptr
end

class c_rightreservoirwithimplantedohmic : unit ptr -> c_rightreservoirwithimplantedohmic_t

module RightReservoirWithImplantedOhmic : sig
  type t = c_rightreservoirwithimplantedohmic

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> Connection.Connection.t -> Connection.Connection.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> string
  val type_ : t -> string
  val ohmic : t -> Connection.Connection.t
  val leftNeighbor : t -> Connection.Connection.t
end