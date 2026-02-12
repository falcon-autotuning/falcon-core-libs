open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_measurementrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measurementrequest_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MeasurementRequest = struct
  type t = c_measurementrequest

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.measurementrequest_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_measurementrequest ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measurementrequest_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_measurementrequest ptr

  let make (message : string) (measurement_name : string) (waveforms : Listwaveform.ListWaveform.t) (getters : Ports.Ports.t) (meter_transforms : Mapinstrumentportporttransform.MapInstrumentPortPortTransform.t) (time_domain : Labelleddomain.LabelledDomain.t) : t =
    Error_handling.multi_read [waveforms; getters; meter_transforms; time_domain] (fun () ->
      let ptr = Capi_bindings.measurementrequest_create (Capi_bindings.string_wrap message) (Capi_bindings.string_wrap measurement_name) waveforms#raw getters#raw meter_transforms#raw time_domain#raw in
      Error_handling.raise_if_error ();
      new c_measurementrequest ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementrequest_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementrequest_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let measurementName (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_measurement_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let getters (handle : t) : Ports.Ports.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_getters handle#raw in
      Error_handling.raise_if_error ();
      new Ports.c_ports result
    )

  let waveforms (handle : t) : Listwaveform.ListWaveform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_waveforms handle#raw in
      Error_handling.raise_if_error ();
      new Listwaveform.c_listwaveform result
    )

  let meterTransforms (handle : t) : Mapinstrumentportporttransform.MapInstrumentPortPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_meter_transforms handle#raw in
      Error_handling.raise_if_error ();
      new Mapinstrumentportporttransform.c_mapinstrumentportporttransform result
    )

  let timeDomain (handle : t) : Labelleddomain.LabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_time_domain handle#raw in
      Error_handling.raise_if_error ();
      new Labelleddomain.c_labelleddomain result
    )

  let message (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementrequest_message handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end