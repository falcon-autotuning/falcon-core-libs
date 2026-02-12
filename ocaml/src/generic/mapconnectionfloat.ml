open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_mapconnectionfloat_t = object
  method raw : unit ptr
end
class c_mapconnectionfloat (h : unit ptr) : c_mapconnectionfloat_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapconnectionfloat_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MapConnectionFloat = struct
  type t = c_mapconnectionfloat

  let empty  : t =
    let ptr = Capi_bindings.mapconnectionfloat_create_empty () in
    Error_handling.raise_if_error ();
    new c_mapconnectionfloat ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.mapconnectionfloat_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_mapconnectionfloat ptr
    )

  let make (data : Pairconnectionfloat.PairConnectionFloat.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.mapconnectionfloat_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_mapconnectionfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapconnectionfloat_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_mapconnectionfloat ptr

  let insertOrAssign (handle : t) (key : Connection.Connection.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_insert_or_assign handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.Connection.t) (value : float) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_insert handle#raw key#raw value in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.Connection.t) : float =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_at handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Connection.Connection.t) : unit =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_erase handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.Connection.t) : bool =
    Error_handling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_contains handle#raw key#raw in
      Error_handling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.ListConnection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_keys handle#raw in
      Error_handling.raise_if_error ();
      new Listconnection.c_listconnection result
    )

  let values (handle : t) : Listfloat.ListFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_values handle#raw in
      Error_handling.raise_if_error ();
      new Listfloat.c_listfloat result
    )

  let items (handle : t) : Listpairconnectionfloat.ListPairConnectionFloat.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_items handle#raw in
      Error_handling.raise_if_error ();
      new Listpairconnectionfloat.c_listpairconnectionfloat result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end