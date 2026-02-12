open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listpairstringstring_t = object
  method raw : unit ptr
end
class c_listpairstringstring (h : unit ptr) : c_listpairstringstring_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairstringstring_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairStringString = struct
  type t = c_listpairstringstring

  let empty  : t =
    let ptr = Capi_bindings.listpairstringstring_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairstringstring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.listpairstringstring_copy (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    new c_listpairstringstring ptr

  let fillValue (count : int) (value : string) : t =
    let ptr = Capi_bindings.listpairstringstring_fill_value (Unsigned.Size_t.of_int count) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    new c_listpairstringstring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.listpairstringstring_create (Falcon_string.of_string data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listpairstringstring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairstringstring_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listpairstringstring ptr

  let pushBack (handle : string) (value : string) : unit =
    let result = Capi_bindings.listpairstringstring_push_back (Falcon_string.of_string handle) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    result

  let size (handle : string) : int =
    let result = Capi_bindings.listpairstringstring_size (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Unsigned.Size_t.to_int result

  let empty (handle : string) : bool =
    let result = Capi_bindings.listpairstringstring_empty (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let eraseAt (handle : string) (idx : int) : unit =
    let result = Capi_bindings.listpairstringstring_erase_at (Falcon_string.of_string handle) (Unsigned.Size_t.of_int idx) in
    Error_handling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.listpairstringstring_clear (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    result

  let at (handle : string) (idx : int) : string =
    let result = Capi_bindings.listpairstringstring_at (Falcon_string.of_string handle) (Unsigned.Size_t.of_int idx) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) (out_buffer : string) (buffer_size : int) : int =
    let result = Capi_bindings.listpairstringstring_items (Falcon_string.of_string handle) (Falcon_string.of_string out_buffer) (Unsigned.Size_t.of_int buffer_size) in
    Error_handling.raise_if_error ();
    Unsigned.Size_t.to_int result

  let contains (handle : string) (value : string) : bool =
    let result = Capi_bindings.listpairstringstring_contains (Falcon_string.of_string handle) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    result

  let index (handle : string) (value : string) : int =
    let result = Capi_bindings.listpairstringstring_index (Falcon_string.of_string handle) (Falcon_string.of_string value) in
    Error_handling.raise_if_error ();
    Unsigned.Size_t.to_int result

  let intersection (handle : string) (other : string) : string =
    let result = Capi_bindings.listpairstringstring_intersection (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.listpairstringstring_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.listpairstringstring_not_equal (Falcon_string.of_string handle) (Falcon_string.of_string other) in
    Error_handling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.listpairstringstring_to_json_string (Falcon_string.of_string handle) in
    Error_handling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end