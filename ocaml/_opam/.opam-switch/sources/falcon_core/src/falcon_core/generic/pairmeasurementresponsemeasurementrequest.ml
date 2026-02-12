open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Communications.Messages

class c_pairmeasurementresponsemeasurementrequest (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairmeasurementresponsemeasurementrequest_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairMeasurementResponseMeasurementRequest = struct
  type t = c_pairmeasurementresponsemeasurementrequest

  let make (first : MeasurementResponse.t) (second : MeasurementRequest.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairmeasurementresponsemeasurementrequest ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairmeasurementresponsemeasurementrequest ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairmeasurementresponsemeasurementrequest ptr

  let first (handle : t) : MeasurementResponse.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementresponse result
    )

  let second (handle : t) : MeasurementRequest.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementrequest result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end