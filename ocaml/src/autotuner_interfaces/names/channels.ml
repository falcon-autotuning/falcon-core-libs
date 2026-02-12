open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_channels (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.channels_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Channels = struct
  type t = c_channels

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.channels_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_channels ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.channels_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_channels ptr

  let empty () : t =
    let ptr = Capi_bindings.channels_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_channels ptr

  let make (items : Listchannel.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.channels_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_channels ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.channels_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_channels result
    )

  let pushBack (handle : t) (value : Channel.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Channel.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_channel result
    )

  let items (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.channels_items handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let contains (handle : t) (value : Channel.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Channel.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.channels_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end