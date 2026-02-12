open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_point_t = object
  method raw : unit ptr
end
class c_point (h : unit ptr) : c_point_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.point_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Point = struct
  type t = c_point

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.point_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_point ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.point_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_point ptr

  let empty  : t =
    let ptr = Capi_bindings.point_create_empty () in
    Error_handling.raise_if_error ();
    new c_point ptr

  let make (items : Mapconnectiondouble.MapConnectionDouble.t) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [items; unit] (fun () ->
      let ptr = Capi_bindings.point_create items#raw unit#raw in
      Error_handling.raise_if_error ();
      new c_point ptr
    )

  let fromParent (items : Mapconnectionquantity.MapConnectionQuantity.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.point_create_from_parent items#raw in
      Error_handling.raise_if_error ();
      new c_point ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let insertOrAssign (handle : t) (key : Connection.Connection.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.point_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.Connection.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.point_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.Connection.t) : Quantity.Quantity.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Quantity.c_quantity result
    )

  let erase (handle : t) (key : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.point_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let values (handle : t) : Listquantity.ListQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_values handle#raw in
      Error_handling.raise_if_error ();
      new Listquantity.c_listquantity result
    )

  let items (handle : t) : Listpairconnectionquantity.ListPairConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairconnectionquantity.c_listpairconnectionquantity result
    )

  let coordinates (handle : t) : Mapconnectionquantity.MapConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_coordinates handle#raw in
      Error_handling.raise_if_error ();
      new Mapconnectionquantity.c_mapconnectionquantity result
    )

  let connections (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_connections handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let addition (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_addition handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_point result
    )

  let subtraction (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.point_subtraction handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_point result
    )

  let multiplication (handle : t) (scalar : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_multiplication handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_point result
    )

  let division (handle : t) (scalar : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_division handle#raw scalar in
      Error_handling.raise_if_error ();
      new c_point result
    )

  let negation (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.point_negation handle#raw in
      Error_handling.raise_if_error ();
      new c_point result
    )

  let setUnit (handle : t) (unit : Symbolunit.SymbolUnit.t) : unit =
    Error_handling.multi_read [handle; unit] (fun () ->
      let result = Capi_bindings.point_set_unit handle#raw unit#raw in
      Error_handling.raise_if_error ();
      result
    )

end