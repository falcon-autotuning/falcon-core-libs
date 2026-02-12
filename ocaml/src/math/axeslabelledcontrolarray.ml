open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_axeslabelledcontrolarray_t = object
  method raw : unit ptr
end
class c_axeslabelledcontrolarray (h : unit ptr) : c_axeslabelledcontrolarray_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axeslabelledcontrolarray_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module AxesLabelledControlArray = struct
  type t = c_axeslabelledcontrolarray

  let empty  : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray_create_empty () in
    Error_handling.raise_if_error ();
    new c_axeslabelledcontrolarray ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_axeslabelledcontrolarray ptr
    )

  let make (data : Listlabelledcontrolarray.ListLabelledControlArray.t) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray_create data#raw in
      Error_handling.raise_if_error ();
      new c_axeslabelledcontrolarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_axeslabelledcontrolarray ptr

  let pushBack (handle : t) (value : Labelledcontrolarray.LabelledControlArray.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledcontrolarray.LabelledControlArray.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelledcontrolarray.c_labelledcontrolarray result
    )

  let items (handle : t) (out_buffer : Labelledcontrolarray.LabelledControlArray.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Labelledcontrolarray.LabelledControlArray.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledcontrolarray.LabelledControlArray.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_axeslabelledcontrolarray result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end