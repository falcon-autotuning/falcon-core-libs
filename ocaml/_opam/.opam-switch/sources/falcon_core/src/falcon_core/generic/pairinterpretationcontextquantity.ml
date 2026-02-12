open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Interpretations
open Falcon_core.Math

class c_pairinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairInterpretationContextQuantity = struct
  type t = c_pairinterpretationcontextquantity

  let make (first : InterpretationContext.t) (second : Quantity.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextquantity_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextquantity ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairinterpretationcontextquantity ptr

  let first (handle : t) : InterpretationContext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontext result
    )

  let second (handle : t) : Quantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end