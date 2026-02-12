open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Communications.Voltage_states

class c_voltagestatesresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.voltagestatesresponse_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module VoltageStatesResponse = struct
  type t = c_voltagestatesresponse

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.voltagestatesresponse_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_voltagestatesresponse ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.voltagestatesresponse_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_voltagestatesresponse ptr

  let make (message : string) (states : DeviceVoltageStates.t) : t =
    ErrorHandling.read states (fun () ->
      let ptr = Capi_bindings.voltagestatesresponse_create (Capi_bindings.string_wrap message) states#raw in
      ErrorHandling.raise_if_error ();
      new c_voltagestatesresponse ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.voltagestatesresponse_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.voltagestatesresponse_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltagestatesresponse_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let message (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltagestatesresponse_message handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let states (handle : t) : DeviceVoltageStates.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltagestatesresponse_states handle#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestates result
    )

end