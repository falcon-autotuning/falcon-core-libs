open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listmapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listmapstringbool_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListMapStringBool = struct
  type t = c_listmapstringbool

  let empty () : t =
    let ptr = Capi_bindings.listmapstringbool_create_empty () in
    Error_handling.raise_if_error ();
    new c_listmapstringbool ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listmapstringbool_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listmapstringbool ptr
    )

  let fillValue (count : int) (value : Mapstringbool.MapStringBool.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listmapstringbool_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listmapstringbool ptr
    )

  let make (data : Mapstringbool.MapStringBool.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listmapstringbool_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listmapstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listmapstringbool_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listmapstringbool ptr

  let pushBack (handle : t) (value : Mapstringbool.MapStringBool.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listmapstringbool_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Mapstringbool.MapStringBool.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Mapstringbool.c_mapstringbool result
    )

  let items (handle : t) (out_buffer : Mapstringbool.MapStringBool.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listmapstringbool_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Mapstringbool.MapStringBool.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listmapstringbool_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Mapstringbool.MapStringBool.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listmapstringbool_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listmapstringbool_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listmapstringbool result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listmapstringbool_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listmapstringbool_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listmapstringbool_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end