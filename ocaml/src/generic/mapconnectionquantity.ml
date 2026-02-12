open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapconnectionquantity_t = object
  method raw : unit ptr
end
class c_mapconnectionquantity (h : unit ptr) : c_mapconnectionquantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapconnectionquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapConnectionQuantity = struct
  type t = c_mapconnectionquantity

  let empty  : t =
    let ptr = Capi_bindings.mapconnectionquantity_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapconnectionquantity ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapconnectionquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapconnectionquantity ptr
    )

  let make (data : Pairconnectionquantity.PairConnectionQuantity.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapconnectionquantity_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapconnectionquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapconnectionquantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapconnectionquantity ptr

  let insertOrAssign (handle : t) (key : Connection.Connection.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.Connection.t) (value : Quantity.Quantity.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.Connection.t) : Quantity.Quantity.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Quantity.c_quantity result
    )

  let erase (handle : t) (key : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let values (handle : t) : Listquantity.ListQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_values handle#raw in
      Error_handling.raise_if_error ();
      new Listquantity.c_listquantity result
    )

  let items (handle : t) : Listpairconnectionquantity.ListPairConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairconnectionquantity.c_listpairconnectionquantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end