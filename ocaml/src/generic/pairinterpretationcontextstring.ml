open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_pairinterpretationcontextstring_t = object
  method raw : unit ptr
end
class c_pairinterpretationcontextstring (h : unit ptr) : c_pairinterpretationcontextstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairinterpretationcontextstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairInterpretationContextString = struct
  type t = c_pairinterpretationcontextstring

  let make (first : Interpretationcontext.InterpretationContext.t) (second : string) : t =
    Error_handling.read first (fun () ->
      let ptr = Capi_bindings.pairinterpretationcontextstring_create first#raw (Falcon_string.of_string second) in
      Error_handling.raise_if_error ();
      new c_pairinterpretationcontextstring ptr
    )

  let copy (handle : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_pairinterpretationcontextstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairinterpretationcontextstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_pairinterpretationcontextstring ptr

  let first (handle : string) : Interpretationcontext.InterpretationContext.t =
    let result = Capi_bindings.pairinterpretationcontextstring_first (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new Interpretationcontext.c_interpretationcontext result

  let second (handle : string) : string =
    let result = Capi_bindings.pairinterpretationcontextstring_second (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairinterpretationcontextstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairinterpretationcontextstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.pairinterpretationcontextstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end