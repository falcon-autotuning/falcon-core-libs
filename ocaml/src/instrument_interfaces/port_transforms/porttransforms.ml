open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_porttransforms (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.porttransforms_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module PortTransforms = struct
  type t = c_porttransforms

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.porttransforms_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_porttransforms ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.porttransforms_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_porttransforms ptr

  let empty () : t =
    let ptr = Capi_bindings.porttransforms_create_empty () in
    Error_handling.raise_if_error ();
    new c_porttransforms ptr

  let make (handle : Listporttransform.ListPortTransform.t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.porttransforms_create handle#raw in
      Error_handling.raise_if_error ();
      new c_porttransforms ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let transforms (handle : t) : Listporttransform.ListPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_transforms handle#raw in
      Error_handling.raise_if_error ();
      new Listporttransform.c_listporttransform result
    )

  let pushBack (handle : t) (value : Porttransform.PortTransform.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Porttransform.PortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Porttransform.c_porttransform result
    )

  let items (handle : t) : Listporttransform.ListPortTransform.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.porttransforms_items handle#raw in
      Error_handling.raise_if_error ();
      new Listporttransform.c_listporttransform result
    )

  let contains (handle : t) (value : Porttransform.PortTransform.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Porttransform.PortTransform.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.porttransforms_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.porttransforms_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_porttransforms result
    )

end