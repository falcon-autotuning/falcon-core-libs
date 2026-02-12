open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_axescontrolarray_t = object
  method raw : unit ptr
end
class c_axescontrolarray (h : unit ptr) : c_axescontrolarray_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axescontrolarray_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module AxesControlArray = struct
  type t = c_axescontrolarray

  let empty  : t =
    let ptr = Capi_bindings.axescontrolarray_create_empty () in
    Error_handling.raise_if_error ();
    new c_axescontrolarray ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.axescontrolarray_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_axescontrolarray ptr
    )

  let make (data : Listcontrolarray.ListControlArray.t) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.axescontrolarray_create data#raw in
      Error_handling.raise_if_error ();
      new c_axescontrolarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axescontrolarray_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_axescontrolarray ptr

  let pushBack (handle : t) (value : Controlarray.ControlArray.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axescontrolarray_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Controlarray.ControlArray.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Controlarray.c_controlarray result
    )

  let items (handle : t) (out_buffer : Controlarray.ControlArray.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axescontrolarray_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Controlarray.ControlArray.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axescontrolarray_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Controlarray.ControlArray.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axescontrolarray_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axescontrolarray_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_axescontrolarray result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axescontrolarray_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axescontrolarray_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axescontrolarray_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end