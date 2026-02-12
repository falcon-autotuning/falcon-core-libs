open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Instrument_interfaces.Port_transforms

class c_pairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinstrumentportporttransform_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairInstrumentPortPortTransform = struct
  type t = c_pairinstrumentportporttransform

  let make (first : InstrumentPort.t) (second : PortTransform.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairinstrumentportporttransform_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairinstrumentportporttransform ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairinstrumentportporttransform_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinstrumentportporttransform_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairinstrumentportporttransform ptr

  let first (handle : t) : InstrumentPort.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let second (handle : t) : PortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransform result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinstrumentportporttransform_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end