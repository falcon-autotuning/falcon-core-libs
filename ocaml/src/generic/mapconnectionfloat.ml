open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_mapconnectionfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapconnectionfloat_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapConnectionFloat = struct
  type t = c_mapconnectionfloat

  let empty () : t =
    let ptr = Capi_bindings.mapconnectionfloat_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapconnectionfloat ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapconnectionfloat_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionfloat ptr
    )

  let make (data : Pairconnectionfloat.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapconnectionfloat_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapconnectionfloat ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapconnectionfloat_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapconnectionfloat ptr

  let insertOrAssign (handle : t) (key : Connection.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_insert_or_assign handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_insert handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : float =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : Listconnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : Listfloat.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listfloat result
    )

  let items (handle : t) : Listpairconnectionfloat.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectionfloat result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectionfloat_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectionfloat_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end