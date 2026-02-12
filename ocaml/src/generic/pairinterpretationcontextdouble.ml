open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairinterpretationcontextdouble_t = object
  method raw : unit ptr
end
class c_pairinterpretationcontextdouble (h : unit ptr) : c_pairinterpretationcontextdouble_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextdouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairInterpretationContextDouble = struct
  type t = c_pairinterpretationcontextdouble

  let make (first : Interpretationcontext.InterpretationContext.t) (second : float) : t =
    Error_handling.read first (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextdouble_create first#raw second in
      Error_handling.raise_if_error ();
      new c_pairinterpretationcontextdouble ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextdouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairinterpretationcontextdouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextdouble_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairinterpretationcontextdouble ptr

  let first (handle : t) : Interpretationcontext.InterpretationContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_first handle#raw in
      Error_handling.raise_if_error ();
      new Interpretationcontext.c_interpretationcontext result
    )

  let second (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_second handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairinterpretationcontextdouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end