open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairconnectionconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairconnectionconnections_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairConnectionConnections = struct
  type t = c_pairconnectionconnections

  let make (first : Connection.Connection.t) (second : Connections.Connections.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairconnectionconnections_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairconnectionconnections ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairconnectionconnections_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairconnectionconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairconnectionconnections_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairconnectionconnections ptr

  let first (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_first handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let second (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_second handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnections_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairconnectionconnections_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairconnectionconnections_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end