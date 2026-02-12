open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math.Domains

class c_measurementrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measurementrequest_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MeasurementRequest = struct
  type t = c_measurementrequest

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.measurementrequest_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementrequest ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measurementrequest_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_measurementrequest ptr

  let make (message : string) (measurement_name : string) (waveforms : ListWaveform.t) (getters : Ports.t) (meter_transforms : MapInstrumentPortPortTransform.t) (time_domain : LabelledDomain.t) : t =
    ErrorHandling.multi_read [waveforms; getters; meter_transforms; time_domain] (fun () ->
      let ptr = Capi_bindings.measurementrequest_create (Capi_bindings.string_wrap message) (Capi_bindings.string_wrap measurement_name) waveforms#raw getters#raw meter_transforms#raw time_domain#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementrequest ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementrequest_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementrequest_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let measurementName (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_measurement_name handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let getters (handle : t) : Ports.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_getters handle#raw in
      ErrorHandling.raise_if_error ();
      new c_ports result
    )

  let waveforms (handle : t) : ListWaveform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_waveforms handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listwaveform result
    )

  let meterTransforms (handle : t) : MapInstrumentPortPortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_meter_transforms handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapinstrumentportporttransform result
    )

  let timeDomain (handle : t) : LabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_time_domain handle#raw in
      ErrorHandling.raise_if_error ();
      new c_labelleddomain result
    )

  let message (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_message handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end