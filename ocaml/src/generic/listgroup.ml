open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listgroup (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listgroup_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListGroup = struct
  type t = c_listgroup

  let empty () : t =
    let ptr = Capi_bindings.listgroup_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listgroup ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listgroup_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgroup ptr
    )

  let fillValue (count : int) (value : Group.t) : t =
    ErrorHandling.read value (fun () ->
      let ptr = Capi_bindings.listgroup_fill_value (Unsigned.Size_t.of_int count) value#raw in
      ErrorHandling.raise_if_error ();
      new c_listgroup ptr
    )

  let make (data : Group.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.listgroup_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_listgroup ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listgroup_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listgroup ptr

  let pushBack (handle : t) (value : Group.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listgroup_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Group.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_group result
    )

  let items (handle : t) (out_buffer : Group.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listgroup_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Group.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listgroup_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Group.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listgroup_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listgroup_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listgroup result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listgroup_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listgroup_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listgroup_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end