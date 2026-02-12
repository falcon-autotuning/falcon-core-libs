open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapinstrumentportporttransform (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinstrumentportporttransform_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapInstrumentPortPortTransform = struct
  type t = c_mapinstrumentportporttransform

  let empty () : t =
    let ptr = Capi_bindings.mapinstrumentportporttransform_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapinstrumentportporttransform ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapinstrumentportporttransform_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapinstrumentportporttransform ptr
    )

  let make (data : Pairinstrumentportporttransform.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapinstrumentportporttransform_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinstrumentportporttransform_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapinstrumentportporttransform ptr

  let insertOrAssign (handle : t) (key : Instrumentport.t) (value : Porttransform.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Instrumentport.t) (value : Porttransform.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Instrumentport.t) : Porttransform.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransform result
    )

  let erase (handle : t) (key : Instrumentport.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Instrumentport.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinstrumentport.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listinstrumentport result
    )

  let values (handle : t) : Listporttransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listporttransform result
    )

  let items (handle : t) : Listpairinstrumentportporttransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairinstrumentportporttransform result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end