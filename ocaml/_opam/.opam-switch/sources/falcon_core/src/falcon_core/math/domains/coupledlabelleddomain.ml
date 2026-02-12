open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math.Domains

class c_coupledlabelleddomain (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.coupledlabelleddomain_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module CoupledLabelledDomain = struct
  type t = c_coupledlabelleddomain

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.coupledlabelleddomain_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_coupledlabelleddomain ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.coupledlabelleddomain_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_coupledlabelleddomain ptr

  let empty () : t =
    let ptr = Capi_bindings.coupledlabelleddomain_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_coupledlabelleddomain ptr

  let make (items : ListLabelledDomain.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.coupledlabelleddomain_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_coupledlabelleddomain ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let domains (handle : t) : ListLabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_domains handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain result
    )

  let labels (handle : t) : Ports.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_labels handle#raw in
      ErrorHandling.raise_if_error ();
      new c_ports result
    )

  let getDomain (handle : t) (search : InstrumentPort.t) : LabelledDomain.t =
    ErrorHandling.multi_read [handle; search] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_get_domain handle#raw search#raw in
      ErrorHandling.raise_if_error ();
      new c_labelleddomain result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_coupledlabelleddomain result
    )

  let pushBack (handle : t) (value : LabelledDomain.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let constAt (handle : t) (idx : int) : LabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_const_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelleddomain result
    )

  let at (handle : t) (idx : int) : LabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_labelleddomain result
    )

  let items (handle : t) : ListLabelledDomain.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listlabelleddomain result
    )

  let contains (handle : t) (value : LabelledDomain.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : LabelledDomain.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.coupledlabelleddomain_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end