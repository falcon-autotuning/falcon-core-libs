open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_labelledarrayslabelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.labelledarrayslabelledcontrolarray_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module LabelledArraysLabelledControlArray = struct
  type t = c_labelledarrayslabelledcontrolarray

  let make (arrays : Listlabelledcontrolarray.t) : t =
    ErrorHandling.read arrays (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledcontrolarray_create arrays#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledcontrolarray_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.labelledarrayslabelledcontrolarray_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_labelledarrayslabelledcontrolarray ptr

  let arrays (handle : t) : Listlabelledcontrolarray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelledcontrolarray result
    )

  let labels (handle : t) : Listacquisitioncontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_labels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listacquisitioncontext result
    )

  let isControlArrays (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_is_control_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isMeasuredArrays (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_is_measured_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let pushBack (handle : t) (value : Labelledcontrolarray.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledcontrolarray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelledcontrolarray result
    )

  let contains (handle : t) (value : Labelledcontrolarray.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledcontrolarray.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledcontrolarray result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledcontrolarray_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end