open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapstringstring_t = object
  method raw : unit ptr
end
class c_mapstringstring (h : unit ptr) : c_mapstringstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapstringstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapStringString = struct
  type t = c_mapstringstring

  let empty  : t =
    let ptr = Capi_bindings.mapstringstring_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.mapstringstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.mapstringstring_create (Falcon_string.of_string data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapstringstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapstringstring ptr

  let insertOrAssign (handle : string) (key : string) (value : string) : unit =
    let result = Capi_bindings.mapstringstring_insert_or_assign (Falcon_string.of_string handle) (Falcon_string.of_string key) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    result

  let insert (handle : string) (key : string) (value : string) : unit =
    let result = Capi_bindings.mapstringstring_insert (Falcon_string.of_string handle) (Falcon_string.of_string key) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    result

  let at (handle : string) (key : string) : string =
    let result = Capi_bindings.mapstringstring_at (Falcon_string.of_string handle) (Falcon_string.of_string key) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let erase (handle : string) (key : string) : unit =
    let result = Capi_bindings.mapstringstring_erase (Falcon_string.of_string handle) (Falcon_string.of_string key) in
    Error_handling.raise_if_error ();
    result

  let size (handle : string) : int =
    let result = Capi_bindings.mapstringstring_size (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Unsigned.Size_t.to_int result

  let empty (handle : string) : bool =
    let result = Capi_bindings.mapstringstring_empty (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.mapstringstring_clear (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let contains (handle : string) (key : string) : bool =
    let result = Capi_bindings.mapstringstring_contains (Falcon_string.of_string handle) (Falcon_string.of_string key) in
    Error_handling.raise_if_error ();
    result

  let keys (handle : string) : string =
    let result = Capi_bindings.mapstringstring_keys (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let values (handle : string) : string =
    let result = Capi_bindings.mapstringstring_values (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) : string =
    let result = Capi_bindings.mapstringstring_items (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapstringstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.mapstringstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.mapstringstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end