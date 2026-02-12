open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_axesinstrumentport_t = object
  method raw : unit ptr
end
class c_axesinstrumentport (h : unit ptr) : c_axesinstrumentport_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axesinstrumentport_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module AxesInstrumentPort = struct
  type t = c_axesinstrumentport

  let empty  : t =
    let ptr = Capi_bindings.axesinstrumentport_create_empty () in
    Error_handling.raise_if_error ();
    new c_axesinstrumentport ptr

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.axesinstrumentport_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_axesinstrumentport ptr
    )

  let make (data : Listinstrumentport.ListInstrumentPort.t) : t =
    Error_handling.read data (fun () ->
      let ptr = Capi_bindings.axesinstrumentport_create data#raw in
      Error_handling.raise_if_error ();
      new c_axesinstrumentport ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axesinstrumentport_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_axesinstrumentport ptr

  let pushBack (handle : t) (value : Instrumentport.InstrumentPort.t) : unit =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_push_back handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_size handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_empty handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_clear handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : Instrumentport.InstrumentPort.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_at handle#raw (Unsigned.Size_t.of_int idx) in
      Error_handling.raise_if_error ();
      new Instrumentport.c_instrumentport result
    )

  let items (handle : t) (out_buffer : Instrumentport.InstrumentPort.t) (buffer_size : int) : int =
    Error_handling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axesinstrumentport_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      Error_handling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : Instrumentport.InstrumentPort.t) : bool =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_contains handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let index (handle : t) (value : Instrumentport.InstrumentPort.t) : int =
    Error_handling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_index handle#raw value#raw in
      Error_handling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_intersection handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_axesinstrumentport result
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end