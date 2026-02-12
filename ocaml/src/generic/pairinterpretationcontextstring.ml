open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextstring_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairInterpretationContextString = struct
  type t = c_pairinterpretationcontextstring

  let make (first : Interpretationcontext.t) (second : string) : t =
    ErrorHandling.read first (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextstring_create first#raw (Capi_bindings.string_wrap second) in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextstring ptr
    )

  let copy (handle : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextstring_copy (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_pairinterpretationcontextstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextstring_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairinterpretationcontextstring ptr

  let first (handle : string) : Interpretationcontext.t =
    let result = Capi_bindings.pairinterpretationcontextstring_first (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_interpretationcontext result

  let second (handle : string) : string =
    let result = Capi_bindings.pairinterpretationcontextstring_second (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairinterpretationcontextstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairinterpretationcontextstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.pairinterpretationcontextstring_to_json_string (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end