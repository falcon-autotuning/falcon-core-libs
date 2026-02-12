open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Physics.Config.Geometries
open Falcon_core.Physics.Device_structures

class c_group (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.group_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Group = struct
  type t = c_group

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.group_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_group ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.group_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_group ptr

  let make (name : Channel.t) (num_dots : int) (screening_gates : Connections.t) (reservoir_gates : Connections.t) (plunger_gates : Connections.t) (barrier_gates : Connections.t) (order : Connections.t) : t =
    ErrorHandling.multi_read [name; screening_gates; reservoir_gates; plunger_gates; barrier_gates; order] (fun () ->
      let ptr = Capi_bindings.group_create name#raw num_dots screening_gates#raw reservoir_gates#raw plunger_gates#raw barrier_gates#raw order#raw in
      ErrorHandling.raise_if_error ();
      new c_group ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.group_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.group_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : Channel.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_name handle#raw in
      ErrorHandling.raise_if_error ();
      new c_channel result
    )

  let numDots (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_num_dots handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let order (handle : t) : GateGeometryArray1D.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_order handle#raw in
      ErrorHandling.raise_if_error ();
      new c_gategeometryarray1d result
    )

  let hasChannel (handle : t) (channel : Channel.t) : bool =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.group_has_channel handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isChargeSensor (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_is_charge_sensor handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getAllChannelGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_all_channel_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let screeningGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_screening_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let reservoirGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_reservoir_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let plungerGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let barrierGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let ohmics (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_ohmics handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let dotGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_dot_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getOhmic (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_ohmic handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getBarrierGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_barrier_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getPlungerGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_plunger_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getReservoirGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_reservoir_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getScreeningGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_screening_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getDotGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_dot_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getAllGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_all_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getAllConnections (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.group_get_all_connections handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let hasOhmic (handle : t) (ohmic : Connection.t) : bool =
    ErrorHandling.multi_read [handle; ohmic] (fun () ->
      let result = Capi_bindings.group_has_ohmic handle#raw ohmic#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasGate (handle : t) (gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; gate] (fun () ->
      let result = Capi_bindings.group_has_gate handle#raw gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasBarrierGate (handle : t) (barrier_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; barrier_gate] (fun () ->
      let result = Capi_bindings.group_has_barrier_gate handle#raw barrier_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasPlungerGate (handle : t) (plunger_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; plunger_gate] (fun () ->
      let result = Capi_bindings.group_has_plunger_gate handle#raw plunger_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasReservoirGate (handle : t) (reservoir_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; reservoir_gate] (fun () ->
      let result = Capi_bindings.group_has_reservoir_gate handle#raw reservoir_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasScreeningGate (handle : t) (screening_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; screening_gate] (fun () ->
      let result = Capi_bindings.group_has_screening_gate handle#raw screening_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end