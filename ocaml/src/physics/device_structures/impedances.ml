open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_impedances_t = object
  method raw : unit ptr
end
class c_impedances (h : unit ptr) : c_impedances_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.impedances_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Impedances = struct
  type t = c_impedances

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.impedances_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_impedances ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.impedances_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_impedances ptr

  let empty  : t =
    let ptr = Capi_bindings.impedances_create_empty () in
    Error_handling.raise_if_error ();
    new c_impedances ptr

  let make (items : Listimpedance.ListImpedance.t) : t =
    Error_handling.read items (fun () ->
      let ptr = Capi_bindings.impedances_create items#raw in
      Error_handling.raise_if_error ();
      new c_impedances ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let pushBack (handle : t) (value : Impedance.Impedance.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_size handle#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Impedance.Impedance.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Impedance.c_impedance result
    )

  let items (handle : t) : Listimpedance.ListImpedance.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedances_items handle#raw in
      Error_handling.raise_if_error ();
      new Listimpedance.c_listimpedance result
    )

  let contains (handle : t) (value : Impedance.Impedance.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedances_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_impedances result
    )

  let index (handle : t) (value : Impedance.Impedance.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.impedances_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      Unsigned.Size_t.to_int result
    )

end