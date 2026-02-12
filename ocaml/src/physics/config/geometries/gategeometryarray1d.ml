open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_gategeometryarray1d_t = object
  method raw : unit ptr
end
class c_gategeometryarray1d (h : unit ptr) : c_gategeometryarray1d_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.gategeometryarray1d_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module GateGeometryArray1D = struct
  type t = c_gategeometryarray1d

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.gategeometryarray1d_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_gategeometryarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.gategeometryarray1d_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_gategeometryarray1d ptr

  let make (lineararray : Connections.Connections.t) (screening_gates : Connections.Connections.t) : t =
    Error_handling.multi_read [lineararray; screening_gates] (fun () ->
      let ptr = Capi_bindings.gategeometryarray1d_create lineararray#raw screening_gates#raw in
      Error_handling.raise_if_error ();
      new c_gategeometryarray1d ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gategeometryarray1d_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.gategeometryarray1d_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let appendCentralGate (handle : t) (left_neighbor : Connection.Connection.t) (selected_gate : Connection.Connection.t) (right_neighbor : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; left_neighbor; selected_gate; right_neighbor] (fun () ->
      let result = Capi_bindings.gategeometryarray1d_append_central_gate handle#raw left_neighbor#raw selected_gate#raw right_neighbor#raw in
      Error_handling.raise_if_error ();
      result
    )

  let allDotGates (handle : t) : Dotgateswithneighbors.DotGatesWithNeighbors.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_all_dot_gates handle#raw in
      Error_handling.raise_if_error ();
      new Dotgateswithneighbors.c_dotgateswithneighbors result
    )

  let queryNeighbors (handle : t) (gate : Connection.Connection.t) : Connections.Connections.t =
    Error_handling.multi_read [handle; gate] (fun () ->
      let result = Capi_bindings.gategeometryarray1d_query_neighbors handle#raw gate#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let leftReservoir (handle : t) : Leftreservoirwithimplantedohmic.LeftReservoirWithImplantedOhmic.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_left_reservoir handle#raw in
      Error_handling.raise_if_error ();
      new Leftreservoirwithimplantedohmic.c_leftreservoirwithimplantedohmic result
    )

  let rightReservoir (handle : t) : Rightreservoirwithimplantedohmic.RightReservoirWithImplantedOhmic.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_right_reservoir handle#raw in
      Error_handling.raise_if_error ();
      new Rightreservoirwithimplantedohmic.c_rightreservoirwithimplantedohmic result
    )

  let leftBarrier (handle : t) : Dotgatewithneighbors.DotGateWithNeighbors.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_left_barrier handle#raw in
      Error_handling.raise_if_error ();
      new Dotgatewithneighbors.c_dotgatewithneighbors result
    )

  let rightBarrier (handle : t) : Dotgatewithneighbors.DotGateWithNeighbors.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_right_barrier handle#raw in
      Error_handling.raise_if_error ();
      new Dotgatewithneighbors.c_dotgatewithneighbors result
    )

  let linearArray (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_linear_array handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let screeningGates (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_screening_gates handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let rawCentralGates (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_raw_central_gates handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let centralDotGates (handle : t) : Dotgateswithneighbors.DotGatesWithNeighbors.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_central_dot_gates handle#raw in
      Error_handling.raise_if_error ();
      new Dotgateswithneighbors.c_dotgateswithneighbors result
    )

  let ohmics (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.gategeometryarray1d_ohmics handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

end