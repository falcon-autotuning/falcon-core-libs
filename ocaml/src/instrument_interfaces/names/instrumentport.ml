open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_instrumentport (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.instrumentport_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module InstrumentPort = struct
  type t = c_instrumentport

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.instrumentport_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_instrumentport ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.instrumentport_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_instrumentport ptr

  let port (default_name : string) (psuedo_name : Connection.Connection.t) (instrument_type : string) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.instrumentport_create_port (Capi_bindings.string_wrap default_name) psuedo_name#raw (Capi_bindings.string_wrap instrument_type) units#raw (Capi_bindings.string_wrap description) in
      Error_handling.raise_if_error ();
      new c_instrumentport ptr
    )

  let knob (default_name : string) (psuedo_name : Connection.Connection.t) (instrument_type : string) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.instrumentport_create_knob (Capi_bindings.string_wrap default_name) psuedo_name#raw (Capi_bindings.string_wrap instrument_type) units#raw (Capi_bindings.string_wrap description) in
      Error_handling.raise_if_error ();
      new c_instrumentport ptr
    )

  let meter (default_name : string) (psuedo_name : Connection.Connection.t) (instrument_type : string) (units : Symbolunit.SymbolUnit.t) (description : string) : t =
    Error_handling.multi_read [psuedo_name; units] (fun () ->
      let ptr = Capi_bindings.instrumentport_create_meter (Capi_bindings.string_wrap default_name) psuedo_name#raw (Capi_bindings.string_wrap instrument_type) units#raw (Capi_bindings.string_wrap description) in
      Error_handling.raise_if_error ();
      new c_instrumentport ptr
    )

  let timer () : t =
    let ptr = Capi_bindings.instrumentport_create_timer () in
    Error_handling.raise_if_error ();
    new c_instrumentport ptr

  let executionClock () : t =
    let ptr = Capi_bindings.instrumentport_create_execution_clock () in
    Error_handling.raise_if_error ();
    new c_instrumentport ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.instrumentport_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.instrumentport_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let defaultName (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_default_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let psuedoName (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_psuedo_name handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let instrumentType (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_instrument_type handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let units (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_units handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let description (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_description handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let instrumentFacingName (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_instrument_facing_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let isKnob (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_is_knob handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isMeter (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_is_meter handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isPort (handle : t) : bool =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.instrumentport_is_port handle#raw in
      Error_handling.raise_if_error ();
      result
    )

end