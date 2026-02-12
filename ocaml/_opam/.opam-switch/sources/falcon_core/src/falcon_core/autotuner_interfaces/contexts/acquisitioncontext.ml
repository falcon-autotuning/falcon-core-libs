open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

class c_acquisitioncontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.acquisitioncontext_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module AcquisitionContext = struct
  type t = c_acquisitioncontext

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.acquisitioncontext_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_acquisitioncontext ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.acquisitioncontext_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_acquisitioncontext ptr

  let make (connection : Connection.t) (instrument_type : string) (units : SymbolUnit.t) : t =
    ErrorHandling.multi_read [connection; units] (fun () ->
      let ptr = Capi_bindings.acquisitioncontext_create connection#raw (Capi_bindings.string_wrap instrument_type) units#raw in
      ErrorHandling.raise_if_error ();
      new c_acquisitioncontext ptr
    )

  let fromPort (port : InstrumentPort.t) : t =
    ErrorHandling.read port (fun () ->
      let ptr = Capi_bindings.acquisitioncontext_create_from_port port#raw in
      ErrorHandling.raise_if_error ();
      new c_acquisitioncontext ptr
    )

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.acquisitioncontext_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.acquisitioncontext_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.acquisitioncontext_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let connection (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.acquisitioncontext_connection handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let instrumentType (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.acquisitioncontext_instrument_type handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let units (handle : t) : SymbolUnit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.acquisitioncontext_units handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let divisionUnit (handle : t) (other : SymbolUnit.t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.acquisitioncontext_division_unit handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_acquisitioncontext result
    )

  let division (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.acquisitioncontext_division handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_acquisitioncontext result
    )

  let matchConnection (handle : t) (other : Connection.t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.acquisitioncontext_match_connection handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let matchInstrumentType (handle : t) (other : string) : bool =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.acquisitioncontext_match_instrument_type handle#raw (Capi_bindings.string_wrap other) in
      ErrorHandling.raise_if_error ();
      result
    )

end