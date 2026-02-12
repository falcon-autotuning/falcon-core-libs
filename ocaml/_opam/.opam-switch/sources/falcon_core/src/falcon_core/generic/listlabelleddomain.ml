open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Math.Domains

class c_listlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.listlabelleddomain_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module ListLabelledDomain = struct
  type t = c_listlabelleddomain

  let empty () : t =
    let ptr = Capi_bindings.listlabelleddomain_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_listlabelleddomain ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.listlabelleddomain_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain ptr
    )

  let fillValue (count : int) (value : LabelledDomain.t) : t =
    ErrorHandling.read value (fun () ->
      let ptr = Capi_bindings.listlabelleddomain_fill_value (Unsigned.Size_t.of_int count) value#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain ptr
    )

  let make (data : LabelledDomain.t) (count : int) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.listlabelleddomain_create data#raw (Unsigned.Size_t.of_int count) in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.listlabelleddomain_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_listlabelleddomain ptr

  let pushBack (handle : t) (value : LabelledDomain.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelleddomain_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : LabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelleddomain result
    )

  let items (handle : t) (out_buffer : LabelledDomain.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.listlabelleddomain_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : LabelledDomain.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelleddomain_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : LabelledDomain.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.listlabelleddomain_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelleddomain_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelleddomain_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.listlabelleddomain_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.listlabelleddomain_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end