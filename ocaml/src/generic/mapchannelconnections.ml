open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapchannelconnections (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapchannelconnections_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapChannelConnections = struct
  type t = c_mapchannelconnections

  let empty () : t =
    let ptr = Capi_bindings.mapchannelconnections_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapchannelconnections ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapchannelconnections_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections ptr
    )

  let make (data : Pairchannelconnections.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapchannelconnections_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapchannelconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapchannelconnections_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapchannelconnections ptr

  let insertOrAssign (handle : t) (key : Channel.t) (value : Connections.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapchannelconnections_insert_or_assign handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Channel.t) (value : Connections.t) : unit =
    ErrorHandling.multi_read [handle; key; value] (fun () ->
      let result = Capi_bindings.mapchannelconnections_insert handle#raw key#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Channel.t) : Connections.t =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      new c_connections result
    )

  let erase (handle : t) (key : Channel.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Channel.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapchannelconnections_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listchannel.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listchannel result
    )

  let values (handle : t) : Listconnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnections result
    )

  let items (handle : t) : Listpairchannelconnections.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairchannelconnections result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapchannelconnections_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapchannelconnections_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapchannelconnections_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end