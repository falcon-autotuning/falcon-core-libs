open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_labelledarrayslabelledmeasuredarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.labelledarrayslabelledmeasuredarray_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module LabelledArraysLabelledMeasuredArray = struct
  type t = c_labelledarrayslabelledmeasuredarray

  let make (arrays : Listlabelledmeasuredarray.t) : t =
    ErrorHandling.read arrays (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledmeasuredarray_create arrays#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledmeasuredarray ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.labelledarrayslabelledmeasuredarray_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledmeasuredarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.labelledarrayslabelledmeasuredarray_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_labelledarrayslabelledmeasuredarray ptr

  let arrays (handle : t) : Listlabelledmeasuredarray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelledmeasuredarray result
    )

  let labels (handle : t) : Listacquisitioncontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_labels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listacquisitioncontext result
    )

  let isControlArrays (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_is_control_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isMeasuredArrays (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_is_measured_arrays handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let pushBack (handle : t) (value : Labelledmeasuredarray.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledmeasuredarray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelledmeasuredarray result
    )

  let contains (handle : t) (value : Labelledmeasuredarray.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledmeasuredarray.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_labelledarrayslabelledmeasuredarray result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.labelledarrayslabelledmeasuredarray_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end