open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Math.Arrays

class c_measurementresponse (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measurementresponse_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MeasurementResponse = struct
  type t = c_measurementresponse

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.measurementresponse_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementresponse ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measurementresponse_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_measurementresponse ptr

  let make (arrays : LabelledArraysLabelledMeasuredArray.t) : t =
    ErrorHandling.read arrays (fun () ->
      let ptr = Capi_bindings.measurementresponse_create arrays#raw in
      ErrorHandling.raise_if_error ();
      new c_measurementresponse ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementresponse_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementresponse_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementresponse_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let arrays (handle : t) : LabelledArraysLabelledMeasuredArray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementresponse_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledmeasuredarray result
    )

  let message (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.measurementresponse_message handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end