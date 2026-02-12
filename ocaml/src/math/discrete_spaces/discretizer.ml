open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_discretizer (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.discretizer_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Discretizer = struct
  type t = c_discretizer

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.discretizer_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_discretizer ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.discretizer_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_discretizer ptr

  let cartesianDiscretizer (delta : float) : t =
    let ptr = Capi_bindings.discretizer_create_cartesian_discretizer delta in
    Error_handling.raise_if_error ();
    new c_discretizer ptr

  let polarDiscretizer (delta : float) : t =
    let ptr = Capi_bindings.discretizer_create_polar_discretizer delta in
    Error_handling.raise_if_error ();
    new c_discretizer ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretizer_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.discretizer_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let delta (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_delta handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let setDelta (handle : t) (delta : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_set_delta handle#raw delta in
      Error_handling.raise_if_error ();
      result
    )

  let domain (handle : t) : Domain.Domain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_domain handle#raw in
      Error_handling.raise_if_error ();
      new Domain.c_domain result
    )

  let isCartesian (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_is_cartesian handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isPolar (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.discretizer_is_polar handle#raw in
      Error_handling.raise_if_error ();
      result
    )

end