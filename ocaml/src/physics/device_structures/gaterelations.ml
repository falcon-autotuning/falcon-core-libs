open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_gaterelations (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.gaterelations_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module GateRelations = struct
  type t = c_gaterelations

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.gaterelations_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_gaterelations ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.gaterelations_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_gaterelations ptr

  let empty () : t =
    let ptr = Capi_bindings.gaterelations_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_gaterelations ptr

  let make (items : Listpairconnectionconnections.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.gaterelations_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_gaterelations ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gaterelations_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gaterelations_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let insertOrAssign (handle : t) (key : Connection.t) (value : Connections.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.gaterelations_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : Connections.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.gaterelations_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : Connections.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.gaterelations_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : Listconnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnections result
    )

  let items (handle : t) : Listpairconnectionconnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.gaterelations_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectionconnections result
    )

end