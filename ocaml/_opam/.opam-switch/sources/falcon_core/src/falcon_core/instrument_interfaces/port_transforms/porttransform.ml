open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math

class c_porttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.porttransform_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PortTransform = struct
  type t = c_porttransform

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.porttransform_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.porttransform_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_porttransform ptr

  let make (port : InstrumentPort.t) (transform : AnalyticFunction.t) : t =
    ErrorHandling.multi_read [port; transform] (fun () ->
      let ptr = Capi_bindings.porttransform_create port#raw transform#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransform ptr
    )

  let constantTransform (port : InstrumentPort.t) (value : float) : t =
    ErrorHandling.read port (fun () ->
      let ptr = Capi_bindings.porttransform_create_constant_transform port#raw value in
      ErrorHandling.raise_if_error ();
      new c_porttransform ptr
    )

  let identityTransform (port : InstrumentPort.t) : t =
    ErrorHandling.read port (fun () ->
      let ptr = Capi_bindings.porttransform_create_identity_transform port#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransform ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransform_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransform_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransform_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let port (handle : t) : InstrumentPort.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransform_port handle#raw in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let labels (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransform_labels handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let evaluate (handle : t) (args : MapStringDouble.t) (time : float) : float =
    ErrorHandling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.porttransform_evaluate handle#raw args#raw time in
      ErrorHandling.raise_if_error ();
      result
    )

  let evaluateArraywise (handle : t) (args : MapStringDouble.t) (deltaT : float) (maxTime : float) : FArrayDouble.t =
    ErrorHandling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.porttransform_evaluate_arraywise handle#raw args#raw deltaT maxTime in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

end