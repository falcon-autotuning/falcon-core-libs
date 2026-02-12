open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Communications.Messages
open Falcon_core.Communications.Voltage_states
open Falcon_core.Generic
open Falcon_core.Math.Arrays
open Falcon_core.Math

class c_hdf5data (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.hdf5data_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module HDF5Data = struct
  type t = c_hdf5data

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.hdf5data_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_hdf5data ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.hdf5data_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_hdf5data ptr

  let make (shape : AxesInt.t) (unit_domain : AxesControlArray.t) (domain_labels : AxesCoupledLabelledDomain.t) (ranges : LabelledArraysLabelledMeasuredArray.t) (metadata : string) (measurement_title : string) (unique_id : int) (timestamp : int) : t =
    ErrorHandling.multi_read [shape; unit_domain; domain_labels; ranges] (fun () ->
      let ptr = Capi_bindings.hdf5data_create shape#raw unit_domain#raw domain_labels#raw ranges#raw (Capi_bindings.string_wrap metadata) (Capi_bindings.string_wrap measurement_title) unique_id timestamp in
      ErrorHandling.raise_if_error ();
      new c_hdf5data ptr
    )

  let fromFile (path : string) : t =
    let ptr = Capi_bindings.hdf5data_create_from_file (Capi_bindings.string_wrap path) in
    ErrorHandling.raise_if_error ();
    new c_hdf5data ptr

  let fromCommunications (request : MeasurementRequest.t) (response : MeasurementResponse.t) (device_voltage_states : DeviceVoltageStates.t) (session_id16 : int) (measurement_title : string) (unique_id : int) (timestamp : int) : t =
    ErrorHandling.multi_read [request; response; device_voltage_states] (fun () ->
      let ptr = Capi_bindings.hdf5data_create_from_communications request#raw response#raw device_voltage_states#raw session_id16 (Capi_bindings.string_wrap measurement_title) unique_id timestamp in
      ErrorHandling.raise_if_error ();
      new c_hdf5data ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.hdf5data_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.hdf5data_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let toFile (handle : t) (path : string) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_file handle#raw (Capi_bindings.string_wrap path) in
      ErrorHandling.raise_if_error ();
      result
    )

  let toCommunications (handle : t) : PairMeasurementResponseMeasurementRequest.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_communications handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairmeasurementresponsemeasurementrequest result
    )

  let shape (handle : t) : AxesInt.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_shape handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesint result
    )

  let unitDomain (handle : t) : AxesControlArray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_unit_domain handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axescontrolarray result
    )

  let domainLabels (handle : t) : AxesCoupledLabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_domain_labels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axescoupledlabelleddomain result
    )

  let ranges (handle : t) : LabelledArraysLabelledMeasuredArray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_ranges handle#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledmeasuredarray result
    )

  let metadata (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_metadata handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let measurementTitle (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_measurement_title handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let uniqueId (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_unique_id handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let timestamp (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_timestamp handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end