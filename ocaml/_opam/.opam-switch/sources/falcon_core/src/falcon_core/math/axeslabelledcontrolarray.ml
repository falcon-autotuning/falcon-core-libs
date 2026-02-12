open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Math.Arrays

class c_axeslabelledcontrolarray (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axeslabelledcontrolarray_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AxesLabelledControlArray = struct
  type t = c_axeslabelledcontrolarray

  let empty () : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_axeslabelledcontrolarray ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray ptr
    )

  let make (data : ListLabelledControlArray.t) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray_create data#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_axeslabelledcontrolarray ptr

  let pushBack (handle : t) (value : LabelledControlArray.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : LabelledControlArray.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelledcontrolarray result
    )

  let items (handle : t) (out_buffer : LabelledControlArray.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : LabelledControlArray.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : LabelledControlArray.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end