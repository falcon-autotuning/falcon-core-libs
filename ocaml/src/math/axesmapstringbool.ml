open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_axesmapstringbool_t = object
  method raw : unit ptr
end
class c_axesmapstringbool (h : unit ptr) : c_axesmapstringbool_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axesmapstringbool_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module AxesMapStringBool = struct
  type t = c_axesmapstringbool

  let empty  : t =
    let ptr = Capi_bindings.axesmapstringbool_create_empty () in
    Error_handling.raise_if_error ();
    new c_axesmapstringbool ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.axesmapstringbool_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_axesmapstringbool ptr
    )

  let make (data : Listmapstringbool.ListMapStringBool.t) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.axesmapstringbool_create data#raw in
      Error_handling.raise_if_error ();
      new c_axesmapstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axesmapstringbool_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_axesmapstringbool ptr

  let pushBack (handle : t) (value : Mapstringbool.MapStringBool.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Mapstringbool.MapStringBool.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Mapstringbool.c_mapstringbool result
    )

  let items (handle : t) (out_buffer : Mapstringbool.MapStringBool.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axesmapstringbool_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Mapstringbool.MapStringBool.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Mapstringbool.MapStringBool.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_axesmapstringbool result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end