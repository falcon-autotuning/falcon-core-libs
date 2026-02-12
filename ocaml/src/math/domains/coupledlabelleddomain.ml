open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_coupledlabelleddomain_t = object
  method raw : unit ptr
end
class c_coupledlabelleddomain (h : unit ptr) : c_coupledlabelleddomain_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.coupledlabelleddomain_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module CoupledLabelledDomain = struct
  type t = c_coupledlabelleddomain

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.coupledlabelleddomain_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_coupledlabelleddomain ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.coupledlabelleddomain_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_coupledlabelleddomain ptr

  let empty  : t =
    let ptr = Capi_bindings.coupledlabelleddomain_create_empty () in
    Error_handling.raise_if_error ();
    new c_coupledlabelleddomain ptr

  let make (items : Listlabelleddomain.ListLabelledDomain.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.coupledlabelleddomain_create items#raw in
      Error_handling.raise_if_error ();
      new c_coupledlabelleddomain ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let domains (handle : t) : Listlabelleddomain.ListLabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_domains handle#raw in
      Error_handling.raise_if_error ();
      new Listlabelleddomain.c_listlabelleddomain result
    )

  let labels (handle : t) : Ports.Ports.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_labels handle#raw in
      Error_handling.raise_if_error ();
      new Ports.c_ports result
    )

  let getDomain (handle : t) (search : Instrumentport.InstrumentPort.t) : Labelleddomain.LabelledDomain.t =
    Error_handling.multi_read [handle; search] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_get_domain handle#raw search#raw in
      Error_handling.raise_if_error ();
      new Labelleddomain.c_labelleddomain result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_coupledlabelleddomain result
    )

  let pushBack (handle : t) (value : Labelleddomain.LabelledDomain.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let constAt (handle : t) (idx : int) : Labelleddomain.LabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_const_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelleddomain.c_labelleddomain result
    )

  let at (handle : t) (idx : int) : Labelleddomain.LabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Labelleddomain.c_labelleddomain result
    )

  let items (handle : t) : Listlabelleddomain.ListLabelledDomain.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_items handle#raw in
      Error_handling.raise_if_error ();
      new Listlabelleddomain.c_listlabelleddomain result
    )

  let contains (handle : t) (value : Labelleddomain.LabelledDomain.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Labelleddomain.LabelledDomain.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

end