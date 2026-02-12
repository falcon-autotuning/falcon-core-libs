open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_listfloat (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listfloat_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListFloat = struct
  type t = c_listfloat

  let empty () : t =
    let ptr = Capi_bindings.listfloat_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listfloat ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listfloat_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listfloat ptr
    )

  let allocate (count : int) : t =
    let ptr = Capi_bindings.listfloat_allocate (Unsigned.Size_t.of_int count) in
    ErrorHandling.raise_if_error ();
    new c_listfloat ptr

  let fillValue (count : int) (value : float) : t =
    let ptr = Capi_bindings.listfloat_fill_value (Unsigned.Size_t.of_int count) value in
    ErrorHandling.raise_if_error ();
    new c_listfloat ptr

  let make (data : float) (count : int) : t =
    let ptr = Capi_bindings.listfloat_create data (Unsigned.Size_t.of_int count) in
    ErrorHandling.raise_if_error ();
    new c_listfloat ptr

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listfloat_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listfloat ptr

  let pushBack (handle : t) (value : float) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_push_back handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let items (handle : t) (out_buffer : float) (buffer_size : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_items handle#raw out_buffer (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : float) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_contains handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : float) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_index handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfloat_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listfloat result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfloat_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listfloat_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listfloat_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end