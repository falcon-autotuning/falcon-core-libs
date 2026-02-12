open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic

class c_listpairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairinstrumentportporttransform_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListPairInstrumentPortPortTransform = struct
  type t = c_listpairinstrumentportporttransform

  let empty () : t =
    let ptr = Capi_bindings.listpairinstrumentportporttransform_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listpairinstrumentportporttransform ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let fillValue (count : int) (value : PairInstrumentPortPortTransform.t) : t =
    ErrorHandling.read value (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_fill_value (Unsigned.Size_t.of_int count) value#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let make (data : PairInstrumentPortPortTransform.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairinstrumentportporttransform_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listpairinstrumentportporttransform ptr

  let pushBack (handle : t) (value : PairInstrumentPortPortTransform.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : PairInstrumentPortPortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_pairinstrumentportporttransform result
    )

  let items (handle : t) (out_buffer : PairInstrumentPortPortTransform.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : PairInstrumentPortPortTransform.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : PairInstrumentPortPortTransform.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinstrumentportporttransform result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end