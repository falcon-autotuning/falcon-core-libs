open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_gaterelations_t = object
  method raw : unit ptr
end
class c_gaterelations (h : unit ptr) : c_gaterelations_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.gaterelations_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module GateRelations = struct
  type t = c_gaterelations

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.gaterelations_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_gaterelations ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.gaterelations_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_gaterelations ptr

  let empty  : t =
    let ptr = Capi_bindings.gaterelations_create_empty () in
    Error_handling.raise_if_error ();
    new c_gaterelations ptr

  let make (items : Listpairconnectionconnections.ListPairConnectionConnections.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.gaterelations_create items#raw in
      Error_handling.raise_if_error ();
      new c_gaterelations ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gaterelations_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gaterelations_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let insertOrAssign (handle : t) (key : Connection.Connection.t) (value : Connections.Connections.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.gaterelations_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.Connection.t) (value : Connections.Connections.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.gaterelations_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.Connection.t) : Connections.Connections.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let erase (handle : t) (key : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let values (handle : t) : Listconnections.ListConnections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_values handle#raw in
      Error_handling.raise_if_error ();
      new Listconnections.c_listconnections result
    )

  let items (handle : t) : Listpairconnectionconnections.ListPairConnectionConnections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairconnectionconnections.c_listpairconnectionconnections result
    )

end