open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class c_measurementcontext (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.measurementcontext_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module MeasurementContext = struct
  type t = c_measurementcontext

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.measurementcontext_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_measurementcontext ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.measurementcontext_from_json_string (Capi_bindings.string_wrap json) in
    Error_handling.raise_if_error ();
    new c_measurementcontext ptr

  let make (connection : Connection.Connection.t) (instrument_type : string) : t =
    Error_handling.read connection (fun () ->
      let ptr = Capi_bindings.measurementcontext_create connection#raw (Capi_bindings.string_wrap instrument_type) in
      Error_handling.raise_if_error ();
      new c_measurementcontext ptr
    )

  let fromPort (port : Instrumentport.InstrumentPort.t) : t =
    Error_handling.read port (fun () ->
      let ptr = Capi_bindings.measurementcontext_create_from_port port#raw in
      Error_handling.raise_if_error ();
      new c_measurementcontext ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementcontext_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.measurementcontext_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementcontext_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let connection (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementcontext_connection handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let instrumentType (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.measurementcontext_instrument_type handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end