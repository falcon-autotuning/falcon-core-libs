open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairconnectionconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionconnections_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairConnectionConnections = struct
  type t = c_pairconnectionconnections

  let make (first : Connection.t) (second : Connections.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairconnectionconnections_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionconnections ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionconnections_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairconnectionconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionconnections_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairconnectionconnections ptr

  let first (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let second (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnections_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnections_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end