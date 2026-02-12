open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_pairchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.pairchannelconnections_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PairChannelConnections = struct
  type t = c_pairchannelconnections

  let make (first : Channel.t) (second : Connections.t) : t =
    ErrorHandling.multi_read [first; second] (fun () ->
      let ptr = Capi_bindings.pairchannelconnections_create first#raw second#raw in
      ErrorHandling.raise_if_error ();
      new c_pairchannelconnections ptr
    )

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.pairchannelconnections_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_pairchannelconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.pairchannelconnections_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_pairchannelconnections ptr

  let first (handle : t) : Channel.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_first handle#raw in
      ErrorHandling.raise_if_error ();
      new c_channel result
    )

  let second (handle : t) : Connections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_second handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairchannelconnections_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.pairchannelconnections_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.pairchannelconnections_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end