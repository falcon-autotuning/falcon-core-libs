open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairstringstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairstringstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairStringString = struct
  type t = c_pairstringstring

  let make (first : string) (second : string) : t =
    let ptr = Capi_bindings.pairstringstring_create (Capi_bindings.string_wrap first) (Capi_bindings.string_wrap second) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.pairstringstring_copy (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairstringstring_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairstringstring ptr

  let first (handle : string) : string =
    let result = Capi_bindings.pairstringstring_first (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let second (handle : string) : string =
    let result = Capi_bindings.pairstringstring_second (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairstringstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.pairstringstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.pairstringstring_to_json_string (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end