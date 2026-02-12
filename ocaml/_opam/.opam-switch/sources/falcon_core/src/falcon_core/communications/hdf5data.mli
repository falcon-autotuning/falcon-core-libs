open Ctypes

open Falcon_core.Communications.Messages
open Falcon_core.Communications.Messages
open Falcon_core.Communications.Voltage_states
open Falcon_core.Generic
open Falcon_core.Math.Arrays
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math

(** Opaque handle for HDF5Data *)
class type c_hdf5data_t = object
  method raw : unit ptr
end

class c_hdf5data : unit ptr -> c_hdf5data_t

module HDF5Data : sig
  type t = c_hdf5data

end

module HDF5Data : sig
  type t = c_hdf5data

  val copy : t -> t
  val fromjson : string -> t
  val make : AxesInt.t -> AxesControlArray.t -> AxesCoupledLabelledDomain.t -> LabelledArraysLabelledMeasuredArray.t -> string -> string -> int -> int -> t
  val fromFile : string -> t
  val fromCommunications : MeasurementRequest.t -> MeasurementResponse.t -> DeviceVoltageStates.t -> int -> string -> int -> int -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val toFile : t -> string -> unit
  val toCommunications : t -> PairMeasurementResponseMeasurementRequest.t
  val shape : t -> AxesInt.t
  val unitDomain : t -> AxesControlArray.t
  val domainLabels : t -> AxesCoupledLabelledDomain.t
  val ranges : t -> LabelledArraysLabelledMeasuredArray.t
  val metadata : t -> string
  val measurementTitle : t -> string
  val uniqueId : t -> int
  val timestamp : t -> int
end