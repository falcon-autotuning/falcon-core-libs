open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listpairinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairinstrumentportporttransform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairInstrumentPortPortTransform = struct
  type t = c_listpairinstrumentportporttransform

  let empty () : t =
    let ptr = Capi_bindings.listpairinstrumentportporttransform_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairinstrumentportporttransform ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let fillValue (count : int) (value : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let make (data : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listpairinstrumentportporttransform_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listpairinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairinstrumentportporttransform_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listpairinstrumentportporttransform ptr

  let pushBack (handle : t) (value : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Pairinstrumentportporttransform.c_pairinstrumentportporttransform result
    )

  let items (handle : t) (out_buffer : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listpairinstrumentportporttransform result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairinstrumentportporttransform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end