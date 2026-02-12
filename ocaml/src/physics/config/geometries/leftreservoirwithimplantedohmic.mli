open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for LeftReservoirWithImplantedOhmic *)
class type c_leftreservoirwithimplantedohmic_t = object
  method raw : unit ptr
end

class c_leftreservoirwithimplantedohmic : unit ptr -> c_leftreservoirwithimplantedohmic_t

module LeftReservoirWithImplantedOhmic : sig
  type t = c_leftreservoirwithimplantedohmic

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> Connection.Connection.t -> Connection.Connection.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> string
  val type_ : t -> string
  val ohmic : t -> Connection.Connection.t
  val rightNeighbor : t -> Connection.Connection.t
end