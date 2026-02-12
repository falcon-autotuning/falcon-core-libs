open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listlabelledmeasuredarray_t = object
  method raw : unit ptr
end
class c_listlabelledmeasuredarray (h : unit ptr) : c_listlabelledmeasuredarray_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listlabelledmeasuredarray_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListLabelledMeasuredArray = struct
  type t = c_listlabelledmeasuredarray

  let empty  : t =
    let ptr = Capi_bindings.listlabelledmeasuredarray_create_empty () in
    Error_handling.raise_if_error ();
    new c_listlabelledmeasuredarray ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listlabelledmeasuredarray_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledmeasuredarray ptr
    )

  let fillValue (count : int) (value : Labelledmeasuredarray.LabelledMeasuredArray.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listlabelledmeasuredarray_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledmeasuredarray ptr
    )

  let make (data : Labelledmeasuredarray.LabelledMeasuredArray.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listlabelledmeasuredarray_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listlabelledmeasuredarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listlabelledmeasuredarray_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listlabelledmeasuredarray ptr

  let pushBack (handle : t) (value : Labelledmeasuredarray.LabelledMeasuredArray.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledmeasuredarray.LabelledMeasuredArray.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelledmeasuredarray.c_labelledmeasuredarray result
    )

  let items (handle : t) (out_buffer : Labelledmeasuredarray.LabelledMeasuredArray.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Labelledmeasuredarray.LabelledMeasuredArray.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledmeasuredarray.LabelledMeasuredArray.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledmeasuredarray result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledmeasuredarray_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end