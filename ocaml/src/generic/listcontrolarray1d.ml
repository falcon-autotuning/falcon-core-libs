open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listcontrolarray1d_t = object
  method raw : unit ptr
end
class c_listcontrolarray1d (h : unit ptr) : c_listcontrolarray1d_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listcontrolarray1d_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListControlArray1D = struct
  type t = c_listcontrolarray1d

  let empty  : t =
    let ptr = Capi_bindings.listcontrolarray1d_create_empty () in
    Error_handling.raise_if_error ();
    new c_listcontrolarray1d ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listcontrolarray1d_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listcontrolarray1d ptr
    )

  let fillValue (count : int) (value : Controlarray1d.ControlArray1D.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listcontrolarray1d_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listcontrolarray1d ptr
    )

  let make (data : Controlarray1d.ControlArray1D.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listcontrolarray1d_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listcontrolarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listcontrolarray1d_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listcontrolarray1d ptr

  let pushBack (handle : t) (value : Controlarray1d.ControlArray1D.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Controlarray1d.ControlArray1D.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Controlarray1d.c_controlarray1d result
    )

  let items (handle : t) (out_buffer : Controlarray1d.ControlArray1D.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Controlarray1d.ControlArray1D.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Controlarray1d.ControlArray1D.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listcontrolarray1d result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listcontrolarray1d_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listcontrolarray1d_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end