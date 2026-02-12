open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

class c_mapconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.mapconnectiondouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module MapConnectionDouble = struct
  type t = c_mapconnectiondouble

  let empty () : t =
    let ptr = Capi_bindings.mapconnectiondouble_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_mapconnectiondouble ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.mapconnectiondouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_mapconnectiondouble ptr
    )

  let make (data : PairConnectionDouble.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.mapconnectiondouble_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_mapconnectiondouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.mapconnectiondouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_mapconnectiondouble ptr

  let insertOrAssign (handle : t) (key : Connection.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_insert_or_assign handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let insert (handle : t) (key : Connection.t) (value : float) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_insert handle#raw key#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (key : Connection.t) : float =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_at handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let erase (handle : t) (key : Connection.t) : unit =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_erase handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (key : Connection.t) : bool =
    ErrorHandling.multi_read [handle; key] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_contains handle#raw key#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let keys (handle : t) : ListConnection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_keys handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listconnection result
    )

  let values (handle : t) : ListDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_values handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listdouble result
    )

  let items (handle : t) : ListPairConnectionDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectiondouble result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.mapconnectiondouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.mapconnectiondouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end