open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_liststring (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.liststring_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListString = struct
  type t = c_liststring

  let empty () : t =
    let ptr = Capi_bindings.liststring_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let copy (handle : string) : t =
    let ptr = Capi_bindings.liststring_copy (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let allocate (count : int) : t =
    let ptr = Capi_bindings.liststring_allocate (Unsigned.Size_t.of_int count) in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let fillValue (count : int) (value : string) : t =
    let ptr = Capi_bindings.liststring_fill_value (Unsigned.Size_t.of_int count) (Capi_bindings.string_wrap value) in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let make (data : string) (count : int) : t =
    let ptr = Capi_bindings.liststring_create (Capi_bindings.string_wrap data) (Unsigned.Size_t.of_int count) in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.liststring_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_liststring ptr

  let pushBack (handle : string) (value : string) : unit =
    let result = Capi_bindings.liststring_push_back (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    ErrorHandling.raise_if_error ();
    result

  let size (handle : string) : int =
    let result = Capi_bindings.liststring_size (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let empty (handle : string) : bool =
    let result = Capi_bindings.liststring_empty (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let eraseAt (handle : string) (idx : int) : unit =
    let result = Capi_bindings.liststring_erase_at (Capi_bindings.string_wrap handle) (Unsigned.Size_t.of_int idx) in
    ErrorHandling.raise_if_error ();
    result

  let clear (handle : string) : unit =
    let result = Capi_bindings.liststring_clear (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    result

  let at (handle : string) (idx : int) : string =
    let result = Capi_bindings.liststring_at (Capi_bindings.string_wrap handle) (Unsigned.Size_t.of_int idx) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let items (handle : string) (out_buffer : string) (buffer_size : int) : int =
    let result = Capi_bindings.liststring_items (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap out_buffer) (Unsigned.Size_t.of_int buffer_size) in
    ErrorHandling.raise_if_error ();
    result

  let contains (handle : string) (value : string) : bool =
    let result = Capi_bindings.liststring_contains (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    ErrorHandling.raise_if_error ();
    result

  let index (handle : string) (value : string) : int =
    let result = Capi_bindings.liststring_index (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap value) in
    ErrorHandling.raise_if_error ();
    result

  let intersection (handle : string) (other : string) : string =
    let result = Capi_bindings.liststring_intersection (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

  let equal (handle : string) (other : string) : bool =
    let result = Capi_bindings.liststring_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let notEqual (handle : string) (other : string) : bool =
    let result = Capi_bindings.liststring_not_equal (Capi_bindings.string_wrap handle) (Capi_bindings.string_wrap other) in
    ErrorHandling.raise_if_error ();
    result

  let toJsonString (handle : string) : string =
    let result = Capi_bindings.liststring_to_json_string (Capi_bindings.string_wrap handle) in
    ErrorHandling.raise_if_error ();
    Capi_bindings.string_to_ocaml result

end