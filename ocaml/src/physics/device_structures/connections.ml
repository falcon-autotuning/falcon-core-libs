open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_connections_t = object
  method raw : unit ptr
end
class c_connections (h : unit ptr) : c_connections_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.connections_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Connections = struct
  type t = c_connections

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.connections_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_connections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.connections_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_connections ptr

  let empty  : t =
    let ptr = Capi_bindings.connections_create_empty () in
    Error_handling.raise_if_error ();
    new c_connections ptr

  let make (items : Listconnection.ListConnection.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.connections_create items#raw in
      Error_handling.raise_if_error ();
      new c_connections ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let isGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isOhmics (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_ohmics handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isDotGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_dot_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isPlungerGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_plunger_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isBarrierGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_barrier_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isReservoirGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_reservoir_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isScreeningGates (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_is_screening_gates handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_connections result
    )

  let pushBack (handle : t) (value : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let items (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.connections_items handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let contains (handle : t) (value : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Connection.Connection.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

end