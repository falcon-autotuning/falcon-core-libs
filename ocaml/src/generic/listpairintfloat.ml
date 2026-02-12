open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listpairintfloat_t = object
  method raw : unit ptr
end
class c_listpairintfloat (h : unit ptr) : c_listpairintfloat_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairintfloat_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairIntFloat = struct
  type t = c_listpairintfloat

  let empty  : t =
    let ptr = Capi_bindings.listpairintfloat_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairintfloat ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listpairintfloat_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listpairintfloat ptr
    )

  let fillValue (count : int) (value : Pairintfloat.PairIntFloat.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listpairintfloat_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listpairintfloat ptr
    )

  let make (data : Pairintfloat.PairIntFloat.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listpairintfloat_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listpairintfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairintfloat_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listpairintfloat ptr

  let pushBack (handle : t) (value : Pairintfloat.PairIntFloat.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairintfloat_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Pairintfloat.PairIntFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Pairintfloat.c_pairintfloat result
    )

  let items (handle : t) (out_buffer : Pairintfloat.PairIntFloat.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairintfloat_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Pairintfloat.PairIntFloat.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairintfloat_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Pairintfloat.PairIntFloat.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairintfloat_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairintfloat_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listpairintfloat result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairintfloat_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairintfloat_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairintfloat_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end