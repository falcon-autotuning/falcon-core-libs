open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names

class c_axesinstrumentport (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.axesinstrumentport_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AxesInstrumentPort = struct
  type t = c_axesinstrumentport

  let empty () : t =
    let ptr = Capi_bindings.axesinstrumentport_create_empty () in
    ErrorHandling.raise_if_error ();
    new c_axesinstrumentport ptr

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.axesinstrumentport_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_axesinstrumentport ptr
    )

  let make (data : ListInstrumentPort.t) : t =
    ErrorHandling.read data (fun () ->
      let ptr = Capi_bindings.axesinstrumentport_create data#raw in
      ErrorHandling.raise_if_error ();
      new c_axesinstrumentport ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.axesinstrumentport_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_axesinstrumentport ptr

  let pushBack (handle : t) (value : InstrumentPort.t) : unit =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_push_back handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let size (handle : t) : int =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_size handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let empty (handle : t) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_empty handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let eraseAt (handle : t) (idx : int) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_erase_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      result
    )

  let clear (handle : t) : unit =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_clear handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let at (handle : t) (idx : int) : InstrumentPort.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_at handle#raw (Unsigned.Size_t.of_int idx) in
      ErrorHandling.raise_if_error ();
      new c_instrumentport result
    )

  let items (handle : t) (out_buffer : InstrumentPort.t) (buffer_size : int) : int =
    ErrorHandling.multi_read [handle; out_buffer] (fun () ->
      let result = Capi_bindings.axesinstrumentport_items handle#raw out_buffer#raw (Unsigned.Size_t.of_int buffer_size) in
      ErrorHandling.raise_if_error ();
      result
    )

  let contains (handle : t) (value : InstrumentPort.t) : bool =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_contains handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let index (handle : t) (value : InstrumentPort.t) : int =
    ErrorHandling.multi_read [handle; value] (fun () ->
      let result = Capi_bindings.axesinstrumentport_index handle#raw value#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let intersection (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_intersection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_axesinstrumentport result
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.axesinstrumentport_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.axesinstrumentport_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end