open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Interpretations

class c_pairinterpretationcontextdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextdouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairInterpretationContextDouble = struct
  type t = c_pairinterpretationcontextdouble

  let make (first : InterpretationContext.t) (second : float) : t =
    ErrorHandling.read first (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextdouble_create first#raw second in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextdouble ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextdouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextdouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairinterpretationcontextdouble ptr

  let first (handle : t) : InterpretationContext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_interpretationcontext result
    )

  let second (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end