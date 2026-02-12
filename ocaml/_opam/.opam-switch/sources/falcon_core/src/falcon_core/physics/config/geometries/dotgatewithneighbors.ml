open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Device_structures

class c_dotgatewithneighbors (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.dotgatewithneighbors_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module DotGateWithNeighbors = struct
  type t = c_dotgatewithneighbors

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.dotgatewithneighbors_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgatewithneighbors ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.dotgatewithneighbors_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_dotgatewithneighbors ptr

  let plungerGateWithNeighbors (name : string) (left_neighbor : Connection.t) (right_neighbor : Connection.t) : t =
    ErrorHandling.multi_read [left_neighbor; right_neighbor] (fun () ->
      let ptr = Capi_bindings.dotgatewithneighbors_create_plunger_gate_with_neighbors (Capi_bindings.string_wrap name) left_neighbor#raw right_neighbor#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgatewithneighbors ptr
    )

  let barrierGateWithNeighbors (name : string) (left_neighbor : Connection.t) (right_neighbor : Connection.t) : t =
    ErrorHandling.multi_read [left_neighbor; right_neighbor] (fun () ->
      let ptr = Capi_bindings.dotgatewithneighbors_create_barrier_gate_with_neighbors (Capi_bindings.string_wrap name) left_neighbor#raw right_neighbor#raw in
      ErrorHandling.raise_if_error ();
      new c_dotgatewithneighbors ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_name handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let type_ (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_type handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let leftNeighbor (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_left_neighbor handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let rightNeighbor (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_right_neighbor handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let isBarrierGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_is_barrier_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isPlungerGate (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.dotgatewithneighbors_is_plunger_gate handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end