open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapinstrumentportporttransform_t = object
  method raw : unit ptr
end
class c_mapinstrumentportporttransform (h : unit ptr) : c_mapinstrumentportporttransform_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapinstrumentportporttransform_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapInstrumentPortPortTransform = struct
  type t = c_mapinstrumentportporttransform

  let empty  : t =
    let ptr = Capi_bindings.mapinstrumentportporttransform_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapinstrumentportporttransform ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapinstrumentportporttransform_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapinstrumentportporttransform ptr
    )

  let make (data : Pairinstrumentportporttransform.PairInstrumentPortPortTransform.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapinstrumentportporttransform_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapinstrumentportporttransform ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapinstrumentportporttransform_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapinstrumentportporttransform ptr

  let insertOrAssign (handle : t) (key : Instrumentport.InstrumentPort.t) (value : Porttransform.PortTransform.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Instrumentport.InstrumentPort.t) (value : Porttransform.PortTransform.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Instrumentport.InstrumentPort.t) : Porttransform.PortTransform.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Porttransform.c_porttransform result
    )

  let erase (handle : t) (key : Instrumentport.InstrumentPort.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Instrumentport.InstrumentPort.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listinstrumentport.ListInstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listinstrumentport.c_listinstrumentport result
    )

  let values (handle : t) : Listporttransform.ListPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_values handle#raw in
      Error_handling.raise_if_error ();
      new Listporttransform.c_listporttransform result
    )

  let items (handle : t) : Listpairinstrumentportporttransform.ListPairInstrumentPortPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairinstrumentportporttransform.c_listpairinstrumentportporttransform result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapinstrumentportporttransform_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end