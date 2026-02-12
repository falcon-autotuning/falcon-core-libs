open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Port_transforms

class c_porttransforms (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.porttransforms_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module PortTransforms = struct
  type t = c_porttransforms

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.porttransforms_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransforms ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.porttransforms_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_porttransforms ptr

  let empty () : t =
    let ptr = Capi_bindings.porttransforms_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_porttransforms ptr

  let make (handle : ListPortTransform.t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.porttransforms_create handle#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransforms ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let transforms (handle : t) : ListPortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_transforms handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listporttransform result
    )

  let pushBack (handle : t) (value : PortTransform.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : PortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_porttransform result
    )

  let items (handle : t) : ListPortTransform.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listporttransform result
    )

  let contains (handle : t) (value : PortTransform.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : PortTransform.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_porttransforms result
    )

end