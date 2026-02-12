open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_channels_t = object
  method raw : unit ptr
end
class c_channels (h : unit ptr) : c_channels_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.channels_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Channels = struct
  type t = c_channels

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.channels_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_channels ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.channels_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_channels ptr

  let empty  : t =
    let ptr = Capi_bindings.channels_create_empty () in
    Error_handling.raise_if_error ();
    new c_channels ptr

  let make (items : Listchannel.ListChannel.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.channels_create items#raw in
      Error_handling.raise_if_error ();
      new c_channels ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_channels result
    )

  let pushBack (handle : t) (value : Channel.Channel.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Channel.Channel.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Channel.c_channel result
    )

  let items (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.channels_items handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let contains (handle : t) (value : Channel.Channel.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Channel.Channel.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

end