open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for GateGeometryArray1D *)
class type c_gategeometryarray1d_t = object
  method raw : unit ptr
end

class c_gategeometryarray1d : unit ptr -> c_gategeometryarray1d_t

module GateGeometryArray1D : sig
  type t = c_gategeometryarray1d

  val copy : t -> t
  val fromjson : string -> t
  val make : Connections.Connections.t -> Connections.Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val appendCentralGate : t -> Connection.Connection.t -> Connection.Connection.t -> Connection.Connection.t -> unit
  val allDotGates : t -> Dotgateswithneighbors.DotGatesWithNeighbors.t
  val queryNeighbors : t -> Connection.Connection.t -> Connections.Connections.t
  val leftReservoir : t -> Leftreservoirwithimplantedohmic.LeftReservoirWithImplantedOhmic.t
  val rightReservoir : t -> Rightreservoirwithimplantedohmic.RightReservoirWithImplantedOhmic.t
  val leftBarrier : t -> Dotgatewithneighbors.DotGateWithNeighbors.t
  val rightBarrier : t -> Dotgatewithneighbors.DotGateWithNeighbors.t
  val linearArray : t -> Connections.Connections.t
  val screeningGates : t -> Connections.Connections.t
  val rawCentralGates : t -> Connections.Connections.t
  val centralDotGates : t -> Dotgateswithneighbors.DotGatesWithNeighbors.t
  val ohmics : t -> Connections.Connections.t
end