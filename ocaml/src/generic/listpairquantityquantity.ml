open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listpairquantityquantity (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairquantityquantity_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListPairQuantityQuantity = struct
  type t = c_listpairquantityquantity

  let empty () : t =
    let ptr = Capi_bindings.listpairquantityquantity_create_empty () in
    Error_handling.raise_if_error ();
    new c_listpairquantityquantity ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listpairquantityquantity_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listpairquantityquantity ptr
    )

  let fillValue (count : int) (value : Pairquantityquantity.PairQuantityQuantity.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listpairquantityquantity_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listpairquantityquantity ptr
    )

  let make (data : Pairquantityquantity.PairQuantityQuantity.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listpairquantityquantity_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listpairquantityquantity ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairquantityquantity_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_listpairquantityquantity ptr

  let pushBack (handle : t) (value : Pairquantityquantity.PairQuantityQuantity.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Pairquantityquantity.PairQuantityQuantity.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Pairquantityquantity.c_pairquantityquantity result
    )

  let items (handle : t) (out_buffer : Pairquantityquantity.PairQuantityQuantity.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Pairquantityquantity.PairQuantityQuantity.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Pairquantityquantity.PairQuantityQuantity.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listpairquantityquantity result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairquantityquantity_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listpairquantityquantity_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end