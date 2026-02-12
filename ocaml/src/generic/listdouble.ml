open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listdouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listdouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListDouble = struct
  type t = c_listdouble

  let empty () : t =
    let ptr = Capi_bindings.listdouble_create_empty () in
    Error_handling.raise_if_error ();
    new c_listdouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listdouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listdouble ptr
    )

  let allocate (count : int) : t =
    let ptr = Capi_bindings.listdouble_allocate (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listdouble ptr

  let fillValue (count : int) (value : float) : t =
    let ptr = Capi_bindings.listdouble_fill_value (Unsigned.Size_t.of_int count) value in
    Error_handling.raise_if_error ();
    new c_listdouble ptr

  let make (data : float) (count : int) : t =
    let ptr = Capi_bindings.listdouble_create data (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listdouble ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listdouble_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listdouble ptr

  let pushBack (handle : t) (value : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_push_back handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let items (handle : t) (out_buffer : float) (buffer_size : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_items handle#raw out_buffer (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_contains handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : float) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_index handle#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdouble_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listdouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end