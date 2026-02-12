open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic

class c_listpairinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairinterpretationcontextquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListPairInterpretationContextQuantity = struct
  type t = c_listpairinterpretationcontextquantity

  let empty () : t =
    let ptr = Capi_bindings.listpairinterpretationcontextquantity_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listpairinterpretationcontextquantity ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listpairinterpretationcontextquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity ptr
    )

  let fillValue (count : int) (value : PairInterpretationContextQuantity.t) : t =
    ErrorHandling.read value (fun () ->
      let ptr = Capi_bindings.listpairinterpretationcontextquantity_fill_value (Unsigned.Size_t.of_int count) value#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity ptr
    )

  let make (data : PairInterpretationContextQuantity.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.listpairinterpretationcontextquantity_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairinterpretationcontextquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listpairinterpretationcontextquantity ptr

  let pushBack (handle : t) (value : PairInterpretationContextQuantity.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : PairInterpretationContextQuantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_pairinterpretationcontextquantity result
    )

  let items (handle : t) (out_buffer : PairInterpretationContextQuantity.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : PairInterpretationContextQuantity.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : PairInterpretationContextQuantity.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairinterpretationcontextquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end