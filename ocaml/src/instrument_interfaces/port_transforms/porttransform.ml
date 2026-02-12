open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_porttransform_t = object
  method raw : unit ptr
end
class c_porttransform (h : unit ptr) : c_porttransform_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.porttransform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PortTransform = struct
  type t = c_porttransform

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.porttransform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_porttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.porttransform_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_porttransform ptr

  let make (port : Instrumentport.InstrumentPort.t) (transform : Analyticfunction.AnalyticFunction.t) : t =
    Error_handling.multi_read [port; transform] (fun () ->
      let ptr = Capi_bindings.porttransform_create port#raw transform#raw in
      Error_handling.raise_if_error ();
      new c_porttransform ptr
    )

  let constantTransform (port : Instrumentport.InstrumentPort.t) (value : float) : t =
    Error_handling.read port (fun () ->
      let ptr = Capi_bindings.porttransform_create_constant_transform port#raw value in
      Error_handling.raise_if_error ();
      new c_porttransform ptr
    )

  let identityTransform (port : Instrumentport.InstrumentPort.t) : t =
    Error_handling.read port (fun () ->
      let ptr = Capi_bindings.porttransform_create_identity_transform port#raw in
      Error_handling.raise_if_error ();
      new c_porttransform ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let port (handle : t) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransform_port handle#raw in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let labels (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransform_labels handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let evaluate (handle : t) (args : Mapstringdouble.MapStringDouble.t) (time : float) : float =
    Error_handling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.porttransform_evaluate handle#raw args#raw time in
      Error_handling.raise_if_error ();
      result
    )

  let evaluateArraywise (handle : t) (args : Mapstringdouble.MapStringDouble.t) (deltaT : float) (maxTime : float) : Farraydouble.FArrayDouble.t =
    Error_handling.multi_read [handle; args] (fun () ->
      let result = Capi_bindings.porttransform_evaluate_arraywise handle#raw args#raw deltaT maxTime in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

end