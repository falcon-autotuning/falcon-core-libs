open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Math.Domains

class c_discretizer (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.discretizer_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Discretizer = struct
  type t = c_discretizer

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.discretizer_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_discretizer ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.discretizer_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_discretizer ptr

  let cartesianDiscretizer (delta : float) : t =
    let ptr = Capi_bindings.discretizer_create_cartesian_discretizer delta in
    ErrorHandling.raise_if_error ();
    new c_discretizer ptr

  let polarDiscretizer (delta : float) : t =
    let ptr = Capi_bindings.discretizer_create_polar_discretizer delta in
    ErrorHandling.raise_if_error ();
    new c_discretizer ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretizer_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretizer_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let delta (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_delta handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let setDelta (handle : t) (delta : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_set_delta handle#raw delta in
      ErrorHandling.raise_if_error ();
      result
    )

  let domain (handle : t) : Domain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_domain handle#raw in
      ErrorHandling.raise_if_error ();
      new c_domain result
    )

  let isCartesian (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_is_cartesian handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isPolar (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.discretizer_is_polar handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end