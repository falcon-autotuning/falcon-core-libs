open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapinterpretationcontextquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinterpretationcontextquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapInterpretationContextQuantity = struct
  type t = c_mapinterpretationcontextquantity

  let empty () : t =
    let ptr = Capi_bindings.mapinterpretationcontextquantity_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextquantity ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapinterpretationcontextquantity ptr
    )

  let make (data : Pairinterpretationcontextquantity.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapinterpretationcontextquantity_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapinterpretationcontextquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinterpretationcontextquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapinterpretationcontextquantity ptr

  let insertOrAssign (handle : t) (key : Interpretationcontext.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Interpretationcontext.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Interpretationcontext.t) : Quantity.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let erase (handle : t) (key : Interpretationcontext.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Interpretationcontext.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinterpretationcontext.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinterpretationcontext result
    )

  let values (handle : t) : Listquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listquantity result
    )

  let items (handle : t) : Listpairinterpretationcontextquantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinterpretationcontextquantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinterpretationcontextquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end