open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_axeslabelledcontrolarray1d (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axeslabelledcontrolarray1d_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AxesLabelledControlArray1D = struct
  type t = c_axeslabelledcontrolarray1d

  let empty () : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray1d_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_axeslabelledcontrolarray1d ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray1d_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray1d ptr
    )

  let make (data : Listlabelledcontrolarray1d.t) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.axeslabelledcontrolarray1d_create data#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray1d ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axeslabelledcontrolarray1d_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_axeslabelledcontrolarray1d ptr

  let pushBack (handle : t) (value : Labelledcontrolarray1d.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Labelledcontrolarray1d.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelledcontrolarray1d result
    )

  let items (handle : t) (out_buffer : Labelledcontrolarray1d.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Labelledcontrolarray1d.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelledcontrolarray1d.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_axeslabelledcontrolarray1d result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axeslabelledcontrolarray1d_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end