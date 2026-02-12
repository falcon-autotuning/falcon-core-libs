open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapfloatfloat_t = object
  method raw : unit ptr
end
class c_mapfloatfloat (h : unit ptr) : c_mapfloatfloat_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapfloatfloat_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapFloatFloat = struct
  type t = c_mapfloatfloat

  let empty  : t =
    let ptr = Capi_bindings.mapfloatfloat_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapfloatfloat ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapfloatfloat_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapfloatfloat ptr
    )

  let make (data : Pairfloatfloat.PairFloatFloat.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapfloatfloat_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapfloatfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapfloatfloat_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapfloatfloat ptr

  let insertOrAssign (handle : t) (key : float) (value : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_insert_or_assign handle#raw key value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : float) (value : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_insert handle#raw key value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : float) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_at handle#raw key in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : float) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_erase handle#raw key in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : float) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_contains handle#raw key in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listfloat.ListFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listfloat.c_listfloat result
    )

  let values (handle : t) : Listfloat.ListFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_values handle#raw in
      Error_handling.raise_if_error ();
      new Listfloat.c_listfloat result
    )

  let items (handle : t) : Listpairfloatfloat.ListPairFloatFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairfloatfloat.c_listpairfloatfloat result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapfloatfloat_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapfloatfloat_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapfloatfloat_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end