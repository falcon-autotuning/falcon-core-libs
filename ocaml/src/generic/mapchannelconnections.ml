open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapchannelconnections_t = object
  method raw : unit ptr
end
class c_mapchannelconnections (h : unit ptr) : c_mapchannelconnections_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapchannelconnections_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapChannelConnections = struct
  type t = c_mapchannelconnections

  let empty  : t =
    let ptr = Capi_bindings.mapchannelconnections_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapchannelconnections ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapchannelconnections_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapchannelconnections ptr
    )

  let make (data : Pairchannelconnections.PairChannelConnections.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapchannelconnections_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapchannelconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapchannelconnections_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapchannelconnections ptr

  let insertOrAssign (handle : t) (key : Channel.Channel.t) (value : Connections.Connections.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapchannelconnections_insert_or_assign handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Channel.Channel.t) (value : Connections.Connections.t) : unit =
    Error_handling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapchannelconnections_insert handle#raw key#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Channel.Channel.t) : Connections.Connections.t =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      new Connections.c_connections result
    )

  let erase (handle : t) (key : Channel.Channel.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Channel.Channel.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listchannel.ListChannel.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listchannel.c_listchannel result
    )

  let values (handle : t) : Listconnections.ListConnections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_values handle#raw in
      Error_handling.raise_if_error ();
      new Listconnections.c_listconnections result
    )

  let items (handle : t) : Listpairchannelconnections.ListPairChannelConnections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairchannelconnections.c_listpairchannelconnections result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapchannelconnections_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapchannelconnections_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end