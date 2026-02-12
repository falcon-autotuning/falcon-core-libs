open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapstringstring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapStringString = struct
  type t = c_mapstringstring

  let empty () : t =
    let ptr = Capi_bindings.mapstringstring_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.mapstringstring_copy (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.mapstringstring_create (Capi_bindings.string_wrap data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringstring_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let insertOrAssign (handle : string) (key : string) (value : string) : unit =
    let result = Capi_bindings.mapstringstring_insert_or_assign (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap key) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    result

  let insert (handle : string) (key : string) (value : string) : unit =
    let result = Capi_bindings.mapstringstring_insert (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap key) (Capi_bindings.string_wrap value) in
    Error_handling.raise_if_error ();
    result

  let at (handle : string) (key : string) : string =
    let result = Capi_bindings.mapstringstring_at (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap key) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let erase (handle : string) (key : string) : unit =
    let result = Capi_bindings.mapstringstring_erase (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap key) in
    Error_handling.raise_if_error ();
    result

  let size (handle : string) : int =
    let result = Capi_bindings.mapstringstring_size (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.mapstringstring_empty (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.mapstringstring_clear (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    result

  let contains (handle : string) (key : string) : bool =
    let result = Capi_bindings.mapstringstring_contains (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap key) in
    Error_handling.raise_if_error ();
    result

  let keys (handle : string) : string =
    let result = Capi_bindings.mapstringstring_keys (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let values (handle : string) : string =
    let result = Capi_bindings.mapstringstring_values (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.mapstringstring_items (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapstringstring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapstringstring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.mapstringstring_to_json_string (Capi_bindings.string_wrap handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end