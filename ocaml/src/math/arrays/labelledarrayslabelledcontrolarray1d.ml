open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_labelledarrayslabelledcontrolarray1d_t = object
  method raw : unit ptr
end
class c_labelledarrayslabelledcontrolarray1d (h : unit ptr) : c_labelledarrayslabelledcontrolarray1d_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.labelledarrayslabelledcontrolarray1d_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module LabelledArraysLabelledControlArray1D = struct
  type t = c_labelledarrayslabelledcontrolarray1d

  let make (arrays : Listlabelledcontrolarray1d.ListLabelledControlArray1D.t) : t =
    Error_handling.read arrays (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledcontrolarray1d_create arrays#raw in
      Error_handling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray1d ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledcontrolarray1d_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.labelledarrayslabelledcontrolarray1d_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_labelledarrayslabelledcontrolarray1d ptr

  let arrays (handle : t) : Listlabelledcontrolarray1d.ListLabelledControlArray1D.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_arrays handle#raw in
      Error_handling.raise_if_error ();
      new Listlabelledcontrolarray1d.c_listlabelledcontrolarray1d result
    )

  let labels (handle : t) : Listacquisitioncontext.ListAcquisitionContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_labels handle#raw in
      Error_handling.raise_if_error ();
      new Listacquisitioncontext.c_listacquisitioncontext result
    )

  let isControlArrays (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_is_control_arrays handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isMeasuredArrays (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_is_measured_arrays handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let pushBack (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledcontrolarray1d.LabelledControlArray1D.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelledcontrolarray1d.c_labelledcontrolarray1d result
    )

  let contains (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledcontrolarray1d.LabelledControlArray1D.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray1d result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray1d_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end