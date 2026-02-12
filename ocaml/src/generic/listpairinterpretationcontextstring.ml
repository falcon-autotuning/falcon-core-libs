open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listpairinterpretationcontextstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairinterpretationcontextstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairInterpretationContextString = struct
  type t = c_listpairinterpretationcontextstring

  let empty () : t =
    let ptr = Capi_bindings.listpairinterpretationcontextstring_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairinterpretationcontextstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.listpairinterpretationcontextstring_copy (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    new c_listpairinterpretationcontextstring ptr

  let fillValue (count : int) (value : string) : t =
    let ptr = Capi_bindings.listpairinterpretationcontextstring_fill_value (Unsigned.Size_t.of_int count) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    new c_listpairinterpretationcontextstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.listpairinterpretationcontextstring_create (Capi_bindings.string_wrap data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listpairinterpretationcontextstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairinterpretationcontextstring_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listpairinterpretationcontextstring ptr

  let pushBack (handle : string) (value : string) : unit =
    let result = Capi_bindings.listpairinterpretationcontextstring_push_back (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    result

  let size (handle : string) : int =
    let result = Capi_bindings.listpairinterpretationcontextstring_size (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.listpairinterpretationcontextstring_empty (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let eraseAt (handle : string) (idx : int) : unit =
    let result = Capi_bindings.listpairinterpretationcontextstring_erase_at (Capi_bindings.string_wrap handle) (Unsigned.Size_t.of_int idx) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.listpairinterpretationcontextstring_clear (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let at (handle : string) (idx : int) : string =
    let result = Capi_bindings.listpairinterpretationcontextstring_at (Capi_bindings.string_wrap handle) (Unsigned.Size_t.of_int idx) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) (out_buffer : string) (buffer_size : int) : int =
    let result = Capi_bindings.listpairinterpretationcontextstring_items (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap out_buffer) (Unsigned.Size_t.of_int buffer_size) in
    Error_handling.raise_if_error ();
    result

  let contains (handle : string) (value : string) : bool =
    let result = Capi_bindings.listpairinterpretationcontextstring_contains (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    result

  let index (handle : string) (value : string) : int =
    let result = Capi_bindings.listpairinterpretationcontextstring_index (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    result

  let intersection (handle : string) (other : string) : string =
    let result = Capi_bindings.listpairinterpretationcontextstring_intersection (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.listpairinterpretationcontextstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.listpairinterpretationcontextstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.listpairinterpretationcontextstring_to_json_string (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end