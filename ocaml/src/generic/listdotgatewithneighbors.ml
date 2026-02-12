open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listdotgatewithneighbors_t = object
  method raw : unit ptr
end
class c_listdotgatewithneighbors (h : unit ptr) : c_listdotgatewithneighbors_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listdotgatewithneighbors_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListDotGateWithNeighbors = struct
  type t = c_listdotgatewithneighbors

  let empty  : t =
    let ptr = Capi_bindings.listdotgatewithneighbors_create_empty () in
    Error_handling.raise_if_error ();
    new c_listdotgatewithneighbors ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listdotgatewithneighbors_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listdotgatewithneighbors ptr
    )

  let fillValue (count : int) (value : Dotgatewithneighbors.DotGateWithNeighbors.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listdotgatewithneighbors_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listdotgatewithneighbors ptr
    )

  let make (data : Dotgatewithneighbors.DotGateWithNeighbors.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listdotgatewithneighbors_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listdotgatewithneighbors ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listdotgatewithneighbors_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listdotgatewithneighbors ptr

  let pushBack (handle : t) (value : Dotgatewithneighbors.DotGateWithNeighbors.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Dotgatewithneighbors.DotGateWithNeighbors.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Dotgatewithneighbors.c_dotgatewithneighbors result
    )

  let items (handle : t) (out_buffer : Dotgatewithneighbors.DotGateWithNeighbors.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Dotgatewithneighbors.DotGateWithNeighbors.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Dotgatewithneighbors.DotGateWithNeighbors.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listdotgatewithneighbors result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listdotgatewithneighbors_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end