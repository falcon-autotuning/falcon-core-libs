open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listlabelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listlabelledcontrolarray1d_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListLabelledControlArray1D = struct
  type t = c_listlabelledcontrolarray1d

  let empty () : t =
    let ptr = Capi_bindings.listlabelledcontrolarray1d_create_empty () in
    Error_handling.raise_if_error ();
    new c_listlabelledcontrolarray1d ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listlabelledcontrolarray1d_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledcontrolarray1d ptr
    )

  let fillValue (count : int) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listlabelledcontrolarray1d_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledcontrolarray1d ptr
    )

  let make (data : Labelledcontrolarray1d.LabelledControlArray1D.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listlabelledcontrolarray1d_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listlabelledcontrolarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listlabelledcontrolarray1d_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listlabelledcontrolarray1d ptr

  let pushBack (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledcontrolarray1d.LabelledControlArray1D.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelledcontrolarray1d.c_labelledcontrolarray1d result
    )

  let items (handle : t) (out_buffer : Labelledcontrolarray1d.LabelledControlArray1D.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listlabelledcontrolarray1d result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listlabelledcontrolarray1d_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end