open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Physics.Config.Core

class c_voltageconstraints (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.voltageconstraints_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module VoltageConstraints = struct
  type t = c_voltageconstraints

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.voltageconstraints_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_voltageconstraints ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.voltageconstraints_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_voltageconstraints ptr

  let make (adjacency : Adjacency.t) (max_safe_diff : float) (bounds : PairDoubleDouble.t) : t =
    ErrorHandling.multi_read [adjacency; bounds] (fun () ->
      let ptr = Capi_bindings.voltageconstraints_create adjacency#raw max_safe_diff bounds#raw in
      ErrorHandling.raise_if_error ();
      new c_voltageconstraints ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.voltageconstraints_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.voltageconstraints_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltageconstraints_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let matrix (handle : t) : FArrayDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltageconstraints_matrix handle#raw in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

  let adjacency (handle : t) : Adjacency.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltageconstraints_adjacency handle#raw in
      ErrorHandling.raise_if_error ();
      new c_adjacency result
    )

  let limits (handle : t) : FArrayDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.voltageconstraints_limits handle#raw in
      ErrorHandling.raise_if_error ();
      new c_farraydouble result
    )

end