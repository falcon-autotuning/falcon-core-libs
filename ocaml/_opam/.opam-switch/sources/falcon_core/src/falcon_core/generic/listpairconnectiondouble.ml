open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic

class c_listpairconnectiondouble (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listpairconnectiondouble_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListPairConnectionDouble = struct
  type t = c_listpairconnectiondouble

  let empty () : t =
    let ptr = Capi_bindings.listpairconnectiondouble_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listpairconnectiondouble ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listpairconnectiondouble_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectiondouble ptr
    )

  let fillValue (count : int) (value : PairConnectionDouble.t) : t =
    ErrorHandling.read value (fun () ->
      let ptr = Capi_bindings.listpairconnectiondouble_fill_value (Unsigned.Size_t.of_int count) value#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectiondouble ptr
    )

  let make (data : PairConnectionDouble.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.listpairconnectiondouble_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectiondouble ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listpairconnectiondouble_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listpairconnectiondouble ptr

  let pushBack (handle : t) (value : PairConnectionDouble.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : PairConnectionDouble.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_pairconnectiondouble result
    )

  let items (handle : t) (out_buffer : PairConnectionDouble.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : PairConnectionDouble.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : PairConnectionDouble.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listpairconnectiondouble result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listpairconnectiondouble_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end