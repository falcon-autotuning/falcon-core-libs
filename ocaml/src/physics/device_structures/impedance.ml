open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_impedance_t = object
  method raw : unit ptr
end
class c_impedance (h : unit ptr) : c_impedance_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.impedance_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module Impedance = struct
  type t = c_impedance

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.impedance_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_impedance ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.impedance_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_impedance ptr

  let make (connection : Connection.Connection.t) (resistance : float) (capacitance : float) : t =
    Error_handling.read connection (fun () ->
      let ptr = Capi_bindings.impedance_create connection#raw resistance capacitance in
      Error_handling.raise_if_error ();
      new c_impedance ptr
    )

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedance_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.impedance_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedance_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let connection (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedance_connection handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let resistance (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedance_resistance handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let capacitance (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.impedance_capacitance handle#raw in
      Error_handling.raise_if_error ();
      result
    )

end