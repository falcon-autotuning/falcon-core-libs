open Ctypes

open Falcon_core.Physics.Config.Geometries
open Falcon_core.Physics.Config.Geometries
open Falcon_core.Physics.Config.Geometries
open Falcon_core.Physics.Config.Geometries
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Device_structures

(** Opaque handle for GateGeometryArray1D *)
class type c_gategeometryarray1d_t = object
  method raw : unit ptr
end

class c_gategeometryarray1d : unit ptr -> c_gategeometryarray1d_t

module GateGeometryArray1D : sig
  type t = c_gategeometryarray1d

end

module GateGeometryArray1D : sig
  type t = c_gategeometryarray1d

  val copy : t -> t
  val fromjson : string -> t
  val make : Connections.t -> Connections.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val appendCentralGate : t -> Connection.t -> Connection.t -> Connection.t -> unit
  val allDotGates : t -> DotGatesWithNeighbors.t
  val queryNeighbors : t -> Connection.t -> Connections.t
  val leftReservoir : t -> LeftReservoirWithImplantedOhmic.t
  val rightReservoir : t -> RightReservoirWithImplantedOhmic.t
  val leftBarrier : t -> DotGateWithNeighbors.t
  val rightBarrier : t -> DotGateWithNeighbors.t
  val linearArray : t -> Connections.t
  val screeningGates : t -> Connections.t
  val rawCentralGates : t -> Connections.t
  val centralDotGates : t -> DotGatesWithNeighbors.t
  val ohmics : t -> Connections.t
end