open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listpairconnectionquantity_t = object
  method raw : unit ptr
end
class c_listpairconnectionquantity (h : unit ptr) : c_listpairconnectionquantity_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairconnectionquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairConnectionQuantity = struct
  type t = c_listpairconnectionquantity

  let empty  : t =
    let ptr = Capi_bindings.listpairconnectionquantity_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairconnectionquantity ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listpairconnectionquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listpairconnectionquantity ptr
    )

  let fillValue (count : int) (value : Pairconnectionquantity.PairConnectionQuantity.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listpairconnectionquantity_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listpairconnectionquantity ptr
    )

  let make (data : Pairconnectionquantity.PairConnectionQuantity.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listpairconnectionquantity_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listpairconnectionquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairconnectionquantity_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listpairconnectionquantity ptr

  let pushBack (handle : t) (value : Pairconnectionquantity.PairConnectionQuantity.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Pairconnectionquantity.PairConnectionQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Pairconnectionquantity.c_pairconnectionquantity result
    )

  let items (handle : t) (out_buffer : Pairconnectionquantity.PairConnectionQuantity.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Pairconnectionquantity.PairConnectionQuantity.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Pairconnectionquantity.PairConnectionQuantity.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listpairconnectionquantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectionquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end