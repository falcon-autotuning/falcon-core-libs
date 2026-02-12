open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Device_structures

class c_mapconnectionquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapconnectionquantity_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapConnectionQuantity = struct
  type t = c_mapconnectionquantity

  let empty () : t =
    let ptr = Capi_bindings.mapconnectionquantity_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapconnectionquantity ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapconnectionquantity_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionquantity ptr
    )

  let make (data : PairConnectionQuantity.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapconnectionquantity_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapconnectionquantity_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapconnectionquantity ptr

  let insertOrAssign (handle : t) (key : Connection.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : Quantity.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : Quantity.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_quantity result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : ListConnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : ListQuantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listquantity result
    )

  let items (handle : t) : ListPairConnectionQuantity.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectionquantity result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionquantity_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionquantity_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end