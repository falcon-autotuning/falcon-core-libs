open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairmeasurementresponsemeasurementrequest_t = object
  method raw : unit ptr
end
class c_pairmeasurementresponsemeasurementrequest (h : unit ptr) : c_pairmeasurementresponsemeasurementrequest_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairmeasurementresponsemeasurementrequest_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairMeasurementResponseMeasurementRequest = struct
  type t = c_pairmeasurementresponsemeasurementrequest

  let make (first : Measurementresponse.MeasurementResponse.t) (second : Measurementrequest.MeasurementRequest.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairmeasurementresponsemeasurementrequest ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairmeasurementresponsemeasurementrequest ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairmeasurementresponsemeasurementrequest_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairmeasurementresponsemeasurementrequest ptr

  let first (handle : t) : Measurementresponse.MeasurementResponse.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_first handle#raw in
      Error_handling.raise_if_error ();
      new Measurementresponse.c_measurementresponse result
    )

  let second (handle : t) : Measurementrequest.MeasurementRequest.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_second handle#raw in
      Error_handling.raise_if_error ();
      new Measurementrequest.c_measurementrequest result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairmeasurementresponsemeasurementrequest_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end