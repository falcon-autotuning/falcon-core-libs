open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_axesint (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axesint_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AxesInt = struct
  type t = c_axesint

  let empty () : t =
    let ptr = Capi_bindings.axesint_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_axesint ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.axesint_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesint ptr
    )

  let make (data : Listint.t) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.axesint_create data#raw in
      ErrorHandling.raise_if_error ();
      new c_axesint ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axesint_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_axesint ptr

  let pushBack (handle : t) (value : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_push_back handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let items (handle : t) (out_buffer : int) (buffer_size : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_items handle#raw out_buffer (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : int) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_contains handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : int) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_index handle#raw value in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesint_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_axesint result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesint_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesint_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesint_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end