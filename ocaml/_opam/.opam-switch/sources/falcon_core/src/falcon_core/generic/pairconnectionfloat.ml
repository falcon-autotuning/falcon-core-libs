open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Device_structures

class c_pairconnectionfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionfloat_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairConnectionFloat = struct
  type t = c_pairconnectionfloat

  let make (first : Connection.t) (second : float) : t =
    ErrorHandling.read first (fun () ->
      let ptr = Capi_bindings.pairconnectionfloat_create first#raw second in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionfloat ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionfloat_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionfloat_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairconnectionfloat ptr

  let first (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let second (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_second handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionfloat_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionfloat_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionfloat_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end