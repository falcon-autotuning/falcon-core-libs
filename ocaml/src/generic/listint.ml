open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listint_t = object
  method raw : unit ptr
end
class c_listint (h : unit ptr) : c_listint_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listint_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListInt = struct
  type t = c_listint

  let empty  : t =
    let ptr = Capi_bindings.listint_create_empty () in
    Error_handling.raise_if_error ();
    new c_listint ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listint_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listint ptr
    )

  let allocate (count : int) : t =
    let ptr = Capi_bindings.listint_allocate (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listint ptr

  let fillValue (count : int) (value : int) : t =
    let ptr = Capi_bindings.listint_fill_value (Unsigned.Size_t.of_int count) value in
    Error_handling.raise_if_error ();
    new c_listint ptr

  let make (data : int) (count : int) : t =
    let ptr = Capi_bindings.listint_create data (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listint ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listint_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listint ptr

  let pushBack (handle : t) (value : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_push_back handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let items (handle : t) (out_buffer : int) (buffer_size : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_items handle#raw out_buffer (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : int) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_contains handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_index handle#raw value in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listint_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listint result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listint_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listint_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listint_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end