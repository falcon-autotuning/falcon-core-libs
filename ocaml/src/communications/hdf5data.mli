open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for HDF5Data *)
class type c_hdf5data_t = object
  method raw : unit ptr
end

class c_hdf5data : unit ptr -> c_hdf5data_t

module HDF5Data : sig
  type t = c_hdf5data

  val copy : t -> t
  val fromjson : string -> t
  val make : Axesint.t -> Axescontrolarray.t -> Axescoupledlabelleddomain.t -> Labelledarrayslabelledmeasuredarray.t -> string -> string -> int -> int -> t
  val fromFile : string -> t
  val fromCommunications : Measurementrequest.t -> Measurementresponse.t -> Devicevoltagestates.t -> int -> string -> int -> int -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val toFile : t -> string -> unit
  val toCommunications : t -> Pairmeasurementresponsemeasurementrequest.t
  val shape : t -> Axesint.t
  val unitDomain : t -> Axescontrolarray.t
  val domainLabels : t -> Axescoupledlabelleddomain.t
  val ranges : t -> Labelledarrayslabelledmeasuredarray.t
  val metadata : t -> string
  val measurementTitle : t -> string
  val uniqueId : t -> int
  val timestamp : t -> int
end