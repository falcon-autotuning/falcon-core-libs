open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

class c_impedances (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.impedances_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module Impedances = struct
  type t = c_impedances

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.impedances_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_impedances ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.impedances_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_impedances ptr

  let empty () : t =
    let ptr = Capi_bindings.impedances_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_impedances ptr

  let make (items : ListImpedance.t) : t =
    ErrorHandling.read items (fun () ->
      let ptr = Capi_bindings.impedances_create items#raw in
      ErrorHandling.raise_if_error ();
      new c_impedances ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let pushBack (handle : t) (value : Impedance.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Impedance.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_impedance result
    )

  let items (handle : t) : ListImpedance.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.impedances_items handle#raw in
      ErrorHandling.raise_if_error ();
      new c_listimpedance result
    )

  let contains (handle : t) (value : Impedance.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_impedances result
    )

  let index (handle : t) (value : Impedance.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end