open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listporttransform_t = object
  method raw : unit ptr
end
class c_listporttransform (h : unit ptr) : c_listporttransform_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listporttransform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPortTransform = struct
  type t = c_listporttransform

  let empty  : t =
    let ptr = Capi_bindings.listporttransform_create_empty () in
    Error_handling.raise_if_error ();
    new c_listporttransform ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listporttransform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listporttransform ptr
    )

  let fillValue (count : int) (value : Porttransform.PortTransform.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listporttransform_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listporttransform ptr
    )

  let make (data : Porttransform.PortTransform.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listporttransform_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listporttransform_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listporttransform ptr

  let pushBack (handle : t) (value : Porttransform.PortTransform.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listporttransform_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Porttransform.PortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Porttransform.c_porttransform result
    )

  let items (handle : t) (out_buffer : Porttransform.PortTransform.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listporttransform_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Porttransform.PortTransform.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listporttransform_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Porttransform.PortTransform.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listporttransform_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listporttransform_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listporttransform result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listporttransform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listporttransform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listporttransform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end