open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_hdf5data (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.hdf5data_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module HDF5Data = struct
  type t = c_hdf5data

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.hdf5data_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_hdf5data ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.hdf5data_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_hdf5data ptr

  let make (shape : Axesint.AxesInt.t) (unit_domain : Axescontrolarray.AxesControlArray.t) (domain_labels : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t) (ranges : Labelledarrayslabelledmeasuredarray.LabelledArraysLabelledMeasuredArray.t) (metadata : string) (measurement_title : string) (unique_id : int) (timestamp : int) : t =
    Error_handling.multi_read [shape; unit_domain; domain_labels; ranges] (fun () ->
      let ptr = Capi_bindings.hdf5data_create shape#raw unit_domain#raw domain_labels#raw ranges#raw (Capi_bindings.string_wrap metadata) (Capi_bindings.string_wrap measurement_title) unique_id timestamp in
      Error_handling.raise_if_error ();
      new c_hdf5data ptr
    )

  let fromFile (path : string) : t =
    let ptr = Capi_bindings.hdf5data_create_from_file (Capi_bindings.string_wrap path) in
    Error_handling.raise_if_error ();
    new c_hdf5data ptr

  let fromCommunications (request : Measurementrequest.MeasurementRequest.t) (response : Measurementresponse.MeasurementResponse.t) (device_voltage_states : Devicevoltagestates.DeviceVoltageStates.t) (session_id16 : int) (measurement_title : string) (unique_id : int) (timestamp : int) : t =
    Error_handling.multi_read [request; response; device_voltage_states] (fun () ->
      let ptr = Capi_bindings.hdf5data_create_from_communications request#raw response#raw device_voltage_states#raw session_id16 (Capi_bindings.string_wrap measurement_title) unique_id timestamp in
      Error_handling.raise_if_error ();
      new c_hdf5data ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.hdf5data_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.hdf5data_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let toFile (handle : t) (path : string) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_file handle#raw (Capi_bindings.string_wrap path) in
      Error_handling.raise_if_error ();
      result
    )

  let toCommunications (handle : t) : Pairmeasurementresponsemeasurementrequest.PairMeasurementResponseMeasurementRequest.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_to_communications handle#raw in
      Error_handling.raise_if_error ();
      new Pairmeasurementresponsemeasurementrequest.c_pairmeasurementresponsemeasurementrequest result
    )

  let shape (handle : t) : Axesint.AxesInt.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_shape handle#raw in
      Error_handling.raise_if_error ();
      new Axesint.c_axesint result
    )

  let unitDomain (handle : t) : Axescontrolarray.AxesControlArray.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_unit_domain handle#raw in
      Error_handling.raise_if_error ();
      new Axescontrolarray.c_axescontrolarray result
    )

  let domainLabels (handle : t) : Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_domain_labels handle#raw in
      Error_handling.raise_if_error ();
      new Axescoupledlabelleddomain.c_axescoupledlabelleddomain result
    )

  let ranges (handle : t) : Labelledarrayslabelledmeasuredarray.LabelledArraysLabelledMeasuredArray.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_ranges handle#raw in
      Error_handling.raise_if_error ();
      new Labelledarrayslabelledmeasuredarray.c_labelledarrayslabelledmeasuredarray result
    )

  let metadata (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_metadata handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let measurementTitle (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_measurement_title handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let uniqueId (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_unique_id handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let timestamp (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.hdf5data_timestamp handle#raw in
      Error_handling.raise_if_error ();
      result
    )

end