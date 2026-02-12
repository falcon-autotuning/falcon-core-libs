open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Generic
open Falcon_core.Physics.Config.Core
open Falcon_core.Physics.Device_structures

class c_config (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.config_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Config = struct
  type t = c_config

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.config_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_config ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.config_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_config ptr

  let make (screening_gates : Connections.t) (plunger_gates : Connections.t) (ohmics : Connections.t) (barrier_gates : Connections.t) (reservoir_gates : Connections.t) (groups : MapGnameGroup.t) (wiring_DC : Impedances.t) (constraints : VoltageConstraints.t) : t =
    ErrorHandling.multi_read [screening_gates; plunger_gates; ohmics; barrier_gates; reservoir_gates; groups; wiring_DC; constraints] (fun () ->
      let ptr = Capi_bindings.config_create screening_gates#raw plunger_gates#raw ohmics#raw barrier_gates#raw reservoir_gates#raw groups#raw wiring_DC#raw constraints#raw in
      ErrorHandling.raise_if_error ();
      new c_config ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.config_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.config_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let numUniqueChannels (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_num_unique_channels handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let voltageConstraints (handle : t) : VoltageConstraints.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_voltage_constraints handle#raw in
      ErrorHandling.raise_if_error ();
      new c_voltageconstraints result
    )

  let groups (handle : t) : MapGnameGroup.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_groups handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapgnamegroup result
    )

  let wiringDc (handle : t) : Impedances.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_wiring_dc handle#raw in
      ErrorHandling.raise_if_error ();
      new c_impedances result
    )

  let channels (handle : t) : Channels.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_channels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_channels result
    )

  let getImpedance (handle : t) (connection : Connection.t) : Impedance.t =
    ErrorHandling.multi_read [handle; connection] (fun () ->
      let result = Capi_bindings.config_get_impedance handle#raw connection#raw in
      ErrorHandling.raise_if_error ();
      new c_impedance result
    )

  let getAllGnames (handle : t) : ListGname.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_all_gnames handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgname result
    )

  let getAllGroups (handle : t) : ListGroup.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_all_groups handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgroup result
    )

  let hasChannel (handle : t) (channel : Channel.t) : bool =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_has_channel handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasGname (handle : t) (gname : Gname.t) : bool =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_has_gname handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let selectGroup (handle : t) (gname : Gname.t) : Group.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_select_group handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_group result
    )

  let getDotNumber (handle : t) (channel : Channel.t) : int =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_dot_number handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getChargeSenseGroups (handle : t) : ListGname.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_charge_sense_groups handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listgname result
    )

  let ohmicInChargeSensor (handle : t) (ohmic : Connection.t) : bool =
    ErrorHandling.multi_read [handle; ohmic] (fun () ->
      let result = Capi_bindings.config_ohmic_in_charge_sensor handle#raw ohmic#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getAssociatedOhmic (handle : t) (reservoir_gate : Connection.t) : Connection.t =
    ErrorHandling.multi_read [handle; reservoir_gate] (fun () ->
      let result = Capi_bindings.config_get_associated_ohmic handle#raw reservoir_gate#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getCurrentChannels (handle : t) : Channels.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_current_channels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_channels result
    )

  let getGname (handle : t) (channel : Channel.t) : Gname.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_gname handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_gname result
    )

  let getGroupBarrierGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_barrier_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getGroupPlungerGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_plunger_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getGroupReservoirGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_reservoir_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getGroupScreeningGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_screening_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getGroupDotGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_dot_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getGroupGates (handle : t) (gname : Gname.t) : Connections.t =
    ErrorHandling.multi_read [handle; gname] (fun () ->
      let result = Capi_bindings.config_get_group_gates handle#raw gname#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelBarrierGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_barrier_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelPlungerGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_plunger_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelReservoirGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_reservoir_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelScreeningGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_screening_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelDotGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_dot_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelOhmics (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_ohmics handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getChannelOrderNoOhmics (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_channel_order_no_ohmics handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getNumUniqueChannels (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_num_unique_channels handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let returnChannelsFromGate (handle : t) (gate : Connection.t) : Channels.t =
    ErrorHandling.multi_read [handle; gate] (fun () ->
      let result = Capi_bindings.config_return_channels_from_gate handle#raw gate#raw in
      ErrorHandling.raise_if_error ();
      new c_channels result
    )

  let returnChannelFromGate (handle : t) (gate : Connection.t) : Channel.t =
    ErrorHandling.multi_read [handle; gate] (fun () ->
      let result = Capi_bindings.config_return_channel_from_gate handle#raw gate#raw in
      ErrorHandling.raise_if_error ();
      new c_channel result
    )

  let ohmicInChannel (handle : t) (ohmic : Connection.t) (channel : Channel.t) : bool =
    ErrorHandling.multi_read [handle; ohmic; channel] (fun () ->
      let result = Capi_bindings.config_ohmic_in_channel handle#raw ohmic#raw channel#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let getDotChannelNeighbors (handle : t) (dot_gate : Connection.t) : PairConnectionConnection.t =
    ErrorHandling.multi_read [handle; dot_gate] (fun () ->
      let result = Capi_bindings.config_get_dot_channel_neighbors handle#raw dot_gate#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionconnection result
    )

  let getBarrierGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_barrier_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getPlungerGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_plunger_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getReservoirGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_reservoir_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getScreeningGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_screening_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getDotGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_dot_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getGateDict (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_gate_dict handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedBarrierGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedPlungerGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedReservoirGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_reservoir_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedScreeningGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_screening_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedDotGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_dot_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedBarrierGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedPlungerGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedReservoirGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_reservoir_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedScreeningGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_screening_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedDotGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_dot_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_shared_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelBarrierGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_barrier_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelPlungerGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_plunger_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelReservoirGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_reservoir_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelScreeningGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_screening_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelDotGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_dot_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getSharedChannelGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_shared_channel_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelBarrierGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_barrier_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelPlungerGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_plunger_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelReservoirGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_reservoir_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelScreeningGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_screening_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelDotGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_dot_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedChannelGates (handle : t) (channel : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; channel] (fun () ->
      let result = Capi_bindings.config_get_isolated_channel_gates handle#raw channel#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getIsolatedBarrierGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_barrier_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedPlungerGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_plunger_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedReservoirGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_reservoir_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedScreeningGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_screening_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedDotGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_dot_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let getIsolatedGatesByChannel (handle : t) : MapChannelConnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_isolated_gates_by_channel handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections result
    )

  let generateGateRelations (handle : t) : GateRelations.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_generate_gate_relations handle#raw in
      ErrorHandling.raise_if_error ();
      new c_gaterelations result
    )

  let screeningGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_screening_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let reservoirGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_reservoir_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let plungerGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_plunger_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let barrierGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_barrier_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let ohmics (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_ohmics handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let dotGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_dot_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getOhmic (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_ohmic handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getBarrierGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_barrier_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getPlungerGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_plunger_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getReservoirGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_reservoir_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getScreeningGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_screening_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getDotGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_dot_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getGate (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_gate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let getAllGates (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_all_gates handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let getAllConnections (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.config_get_all_connections handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let hasOhmic (handle : t) (ohmic : Connection.t) : bool =
    ErrorHandling.multi_read [handle; ohmic] (fun () ->
      let result = Capi_bindings.config_has_ohmic handle#raw ohmic#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasGate (handle : t) (gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; gate] (fun () ->
      let result = Capi_bindings.config_has_gate handle#raw gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasBarrierGate (handle : t) (barrier_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; barrier_gate] (fun () ->
      let result = Capi_bindings.config_has_barrier_gate handle#raw barrier_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasPlungerGate (handle : t) (plunger_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; plunger_gate] (fun () ->
      let result = Capi_bindings.config_has_plunger_gate handle#raw plunger_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasReservoirGate (handle : t) (reservoir_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; reservoir_gate] (fun () ->
      let result = Capi_bindings.config_has_reservoir_gate handle#raw reservoir_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let hasScreeningGate (handle : t) (screening_gate : Connection.t) : bool =
    ErrorHandling.multi_read [handle; screening_gate] (fun () ->
      let result = Capi_bindings.config_has_screening_gate handle#raw screening_gate#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end