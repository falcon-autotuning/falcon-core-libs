open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_listacquisitioncontext_t = object
  method raw : unit ptr
end
class c_listacquisitioncontext (h : unit ptr) : c_listacquisitioncontext_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listacquisitioncontext_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module ListAcquisitionContext = struct
  type t = c_listacquisitioncontext

  let empty  : t =
    let ptr = Capi_bindings.listacquisitioncontext_create_empty () in
    Error_handling.raise_if_error ();
    new c_listacquisitioncontext ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.listacquisitioncontext_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_listacquisitioncontext ptr
    )

  let fillValue (count : int) (value : Acquisitioncontext.AcquisitionContext.t) : t =
    Error_handling.read value (fun () ->
      let ptr = Capi_bindings.listacquisitioncontext_fill_value (Unsigned.Size_t.of_int count) value#raw in
      Error_handling.raise_if_error ();
      new c_listacquisitioncontext ptr
    )

  let make (data : Acquisitioncontext.AcquisitionContext.t) (count : int) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.listacquisitioncontext_create data#raw (Unsigned.Size_t.of_int count) in
      Error_handling.raise_if_error ();
      new c_listacquisitioncontext ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listacquisitioncontext_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_listacquisitioncontext ptr

  let pushBack (handle : t) (value : Acquisitioncontext.AcquisitionContext.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Acquisitioncontext.AcquisitionContext.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Acquisitioncontext.c_acquisitioncontext result
    )

  let items (handle : t) (out_buffer : Acquisitioncontext.AcquisitionContext.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let contains (handle : t) (value : Acquisitioncontext.AcquisitionContext.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Acquisitioncontext.AcquisitionContext.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_listacquisitioncontext result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listacquisitioncontext_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.listacquisitioncontext_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end