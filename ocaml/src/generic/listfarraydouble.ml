open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listfarraydouble_t = object
  method raw : unit ptr
end
class c_listfarraydouble (h : unit ptr) : c_listfarraydouble_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listfarraydouble_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListFArrayDouble = struct
  type t = c_listfarraydouble

  let empty  : t =
    let ptr = Capi_bindings.listfarraydouble_create_empty () in
    Error_handling.raise_if_error ();
    new c_listfarraydouble ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listfarraydouble_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listfarraydouble ptr
    )

  let fillValue (count : int) (value : Farraydouble.FArrayDouble.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listfarraydouble_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listfarraydouble ptr
    )

  let make (data : Farraydouble.FArrayDouble.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listfarraydouble_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listfarraydouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listfarraydouble_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listfarraydouble ptr

  let pushBack (handle : t) (value : Farraydouble.FArrayDouble.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listfarraydouble_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Farraydouble.FArrayDouble.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Farraydouble.c_farraydouble result
    )

  let items (handle : t) (out_buffer : Farraydouble.FArrayDouble.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listfarraydouble_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Farraydouble.FArrayDouble.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listfarraydouble_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Farraydouble.FArrayDouble.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listfarraydouble_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfarraydouble_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listfarraydouble result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfarraydouble_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfarraydouble_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listfarraydouble_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end