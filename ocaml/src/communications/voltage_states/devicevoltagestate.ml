open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_devicevoltagestate_t = object
  method raw : unit ptr
end
class c_devicevoltagestate (h : unit ptr) : c_devicevoltagestate_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.devicevoltagestate_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module DeviceVoltageState = struct
  type t = c_devicevoltagestate

  let make (connection : Connection.Connection.t) (voltage : float) (unit : Symbolunit.SymbolUnit.t) : t =
    Error_handling.multi_read [connection; unit] (fun () ->
      let ptr = Capi_bindings.devicevoltagestate_create connection#raw voltage unit#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.devicevoltagestate_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_devicevoltagestate ptr

  let connection (handle : t) : Connection.Connection.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_connection handle#raw in
      Error_handling.raise_if_error ();
      new Connection.c_connection result
    )

  let voltage (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_voltage handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let value (handle : t) : float =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_value handle#raw in
      Error_handling.raise_if_error ();
      result
    )

  let unit (handle : t) : Symbolunit.SymbolUnit.t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_unit handle#raw in
      Error_handling.raise_if_error ();
      new Symbolunit.c_symbolunit result
    )

  let convertTo (handle : t) (target_unit : Symbolunit.SymbolUnit.t) : unit =
    Error_handling.multi_read [handle; target_unit] (fun () ->
      let result = Capi_bindings.devicevoltagestate_convert_to handle#raw target_unit#raw in
      Error_handling.raise_if_error ();
      result
    )

  let multiplyInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsInt (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_int handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsDouble (handle : t) (other : float) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_double handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let power (handle : t) (other : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_power handle#raw other in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let addQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_add_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let addEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_add_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let subtractQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_subtract_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let subtractEqualsQuantity (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_subtract_equals_quantity handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let negate (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_negate handle#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let abs (handle : t) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_abs handle#raw in
      Error_handling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let equal (a : t) (b : t) : bool =
    Error_handling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestate_equal a#raw b#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (a : t) (b : t) : bool =
    Error_handling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestate_not_equal a#raw b#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end