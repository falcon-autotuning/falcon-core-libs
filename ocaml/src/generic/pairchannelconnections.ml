open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairchannelconnections_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PairChannelConnections = struct
  type t = c_pairchannelconnections

  let make (first : Channel.Channel.t) (second : Connections.Connections.t) : t =
    Error_handling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairchannelconnections_create first#raw second#raw in
      Error_handling.raise_if_error ();
      new c_pairchannelconnections ptr
    )

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.pairchannelconnections_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_pairchannelconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairchannelconnections_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_pairchannelconnections ptr

  let first (handle : t) : Channel.Channel.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_first handle#raw in
      Error_handling.raise_if_error ();
      new Channel.c_channel result
    )

  let second (handle : t) : Connections.Connections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_second handle#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairchannelconnections_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairchannelconnections_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end