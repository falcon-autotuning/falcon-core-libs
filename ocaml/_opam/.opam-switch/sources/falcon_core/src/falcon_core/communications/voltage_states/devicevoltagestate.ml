open Ctypes
open Capi_bindings
open ErrorHandling

open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

class c_devicevoltagestate (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.devicevoltagestate_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module DeviceVoltageState = struct
  type t = c_devicevoltagestate

  let make (connection : Connection.t) (voltage : float) (unit : SymbolUnit.t) : t =
    ErrorHandling.multi_read [connection; unit] (fun () ->
      let ptr = Capi_bindings.devicevoltagestate_create connection#raw voltage unit#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.devicevoltagestate_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_devicevoltagestate ptr

  let connection (handle : t) : Connection.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_connection handle#raw in
      ErrorHandling.raise_if_error ();
      new c_connection result
    )

  let voltage (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_voltage handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let value (handle : t) : float =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_value handle#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let unit (handle : t) : SymbolUnit.t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_unit handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let convertTo (handle : t) (target_unit : SymbolUnit.t) : unit =
    ErrorHandling.multi_read [handle; target_unit] (fun () ->
      let result = Capi_bindings.devicevoltagestate_convert_to handle#raw target_unit#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let multiplyInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let multiplyEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_multiply_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsInt (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_int handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsDouble (handle : t) (other : float) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_double handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let divideEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_divide_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let power (handle : t) (other : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_power handle#raw other in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let addQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_add_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let addEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_add_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let subtractQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_subtract_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let subtractEqualsQuantity (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.devicevoltagestate_subtract_equals_quantity handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let negate (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_negate handle#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let abs (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_abs handle#raw in
      ErrorHandling.raise_if_error ();
      new c_devicevoltagestate result
    )

  let equal (a : t) (b : t) : bool =
    ErrorHandling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestate_equal a#raw b#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (a : t) (b : t) : bool =
    ErrorHandling.multi_read [a; b] (fun () ->
      let result = Capi_bindings.devicevoltagestate_not_equal a#raw b#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.devicevoltagestate_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

end