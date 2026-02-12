open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listpairchannelconnections_t = object
  method raw : unit ptr
end
class c_listpairchannelconnections (h : unit ptr) : c_listpairchannelconnections_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairchannelconnections_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairChannelConnections = struct
  type t = c_listpairchannelconnections

  let empty  : t =
    let ptr = Capi_bindings.listpairchannelconnections_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairchannelconnections ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listpairchannelconnections_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listpairchannelconnections ptr
    )

  let fillValue (count : int) (value : Pairchannelconnections.PairChannelConnections.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listpairchannelconnections_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listpairchannelconnections ptr
    )

  let make (data : Pairchannelconnections.PairChannelConnections.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listpairchannelconnections_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listpairchannelconnections ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairchannelconnections_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listpairchannelconnections ptr

  let pushBack (handle : t) (value : Pairchannelconnections.PairChannelConnections.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Pairchannelconnections.PairChannelConnections.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Pairchannelconnections.c_pairchannelconnections result
    )

  let items (handle : t) (out_buffer : Pairchannelconnections.PairChannelConnections.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Pairchannelconnections.PairChannelConnections.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Pairchannelconnections.PairChannelConnections.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listpairchannelconnections result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairchannelconnections_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairchannelconnections_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end