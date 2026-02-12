open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Device_structures

class c_pairconnectionconnection (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionconnection_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairConnectionConnection = struct
  type t = c_pairconnectionconnection

  let make (first : Connection.t) (second : Connection.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairconnectionconnection_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionconnection ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionconnection_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionconnection ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionconnection_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairconnectionconnection ptr

  let first (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnection_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let second (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnection_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnection_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnection_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnection_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end