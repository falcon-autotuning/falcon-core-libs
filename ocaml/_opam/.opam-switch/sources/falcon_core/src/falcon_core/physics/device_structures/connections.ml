open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

class c_connections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.connections_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Connections = struct
  type t = c_connections

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.connections_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.connections_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_connections ptr

  let empty () : t =
    let ptr = Capi_bindings.connections_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_connections ptr

  let make (items : ListConnection.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.connections_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_connections ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let isGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isOhmics (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_ohmics handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isDotGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_dot_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isPlungerGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isBarrierGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isReservoirGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_reservoir_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isScreeningGates (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_is_screening_gates handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.connections_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let pushBack (handle : t) (value : Connection.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let items (handle : t) : ListConnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.connections_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let contains (handle : t) (value : Connection.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Connection.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.connections_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end