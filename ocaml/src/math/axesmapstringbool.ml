open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_axesmapstringbool (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axesmapstringbool_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AxesMapStringBool = struct
  type t = c_axesmapstringbool

  let empty () : t =
    let ptr = Capi_bindings.axesmapstringbool_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_axesmapstringbool ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.axesmapstringbool_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesmapstringbool ptr
    )

  let make (data : Listmapstringbool.t) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.axesmapstringbool_create data#raw in
      ErrorHandling.raise_if_error ();
      new c_axesmapstringbool ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axesmapstringbool_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_axesmapstringbool ptr

  let pushBack (handle : t) (value : Mapstringbool.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Mapstringbool.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_mapstringbool result
    )

  let items (handle : t) (out_buffer : Mapstringbool.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axesmapstringbool_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Mapstringbool.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Mapstringbool.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesmapstringbool_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_axesmapstringbool result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesmapstringbool_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesmapstringbool_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end