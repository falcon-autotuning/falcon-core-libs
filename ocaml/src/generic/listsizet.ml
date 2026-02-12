open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listsizet (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listsizet_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListSizeT = struct
  type t = c_listsizet

  let empty () : t =
    let ptr = Capi_bindings.listsizet_create_empty () in
    Error_handling.raise_if_error ();
    new c_listsizet ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listsizet_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listsizet ptr
    )

  let allocate (count : int) : t =
    let ptr = Capi_bindings.listsizet_allocate (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listsizet ptr

  let fillValue (count : int) (value : int) : t =
    let ptr = Capi_bindings.listsizet_fill_value (Unsigned.Size_t.of_int count) (Unsigned.Size_t.of_int value) in
    Error_handling.raise_if_error ();
    new c_listsizet ptr

  let make (data : int) (count : int) : t =
    let ptr = Capi_bindings.listsizet_create (Unsigned.Size_t.of_int data) (Unsigned.Size_t.of_int count) in
    Error_handling.raise_if_error ();
    new c_listsizet ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listsizet_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listsizet ptr

  let pushBack (handle : t) (value : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_push_back handle#raw (Unsigned.Size_t.of_int value) in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let items (handle : t) (out_buffer : int) (buffer_size : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_items handle#raw (Unsigned.Size_t.of_int out_buffer) (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : int) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_contains handle#raw (Unsigned.Size_t.of_int value) in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : int) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_index handle#raw (Unsigned.Size_t.of_int value) in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listsizet_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listsizet result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listsizet_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listsizet_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listsizet_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end