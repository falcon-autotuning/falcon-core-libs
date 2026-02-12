open Ctypes
open Capi_bindings
open Error_handling

(* No opens needed - using qualified names *)

class type c_symbolunit_t = object
  method raw : unit ptr
end
class c_symbolunit (h : unit ptr) : c_symbolunit_t = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.symbolunit_destroy raw_val;
    Error_handling.raise_if_error ()
  ) self
end

module SymbolUnit = struct
  type t = c_symbolunit

  let copy (handle : t) : t =
    Error_handling.read handle (fun () ->
      let ptr = Capi_bindings.symbolunit_copy handle#raw in
      Error_handling.raise_if_error ();
      new c_symbolunit ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.symbolunit_from_json_string (Falcon_string.of_string json) in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let meter  : t =
    let ptr = Capi_bindings.symbolunit_create_meter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kilogram  : t =
    let ptr = Capi_bindings.symbolunit_create_kilogram () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let second  : t =
    let ptr = Capi_bindings.symbolunit_create_second () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let ampere  : t =
    let ptr = Capi_bindings.symbolunit_create_ampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kelvin  : t =
    let ptr = Capi_bindings.symbolunit_create_kelvin () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let mole  : t =
    let ptr = Capi_bindings.symbolunit_create_mole () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let candela  : t =
    let ptr = Capi_bindings.symbolunit_create_candela () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let hertz  : t =
    let ptr = Capi_bindings.symbolunit_create_hertz () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let newton  : t =
    let ptr = Capi_bindings.symbolunit_create_newton () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let pascal  : t =
    let ptr = Capi_bindings.symbolunit_create_pascal () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let joule  : t =
    let ptr = Capi_bindings.symbolunit_create_joule () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let watt  : t =
    let ptr = Capi_bindings.symbolunit_create_watt () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let coulomb  : t =
    let ptr = Capi_bindings.symbolunit_create_coulomb () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let volt  : t =
    let ptr = Capi_bindings.symbolunit_create_volt () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let farad  : t =
    let ptr = Capi_bindings.symbolunit_create_farad () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let ohm  : t =
    let ptr = Capi_bindings.symbolunit_create_ohm () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let siemens  : t =
    let ptr = Capi_bindings.symbolunit_create_siemens () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let weber  : t =
    let ptr = Capi_bindings.symbolunit_create_weber () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let tesla  : t =
    let ptr = Capi_bindings.symbolunit_create_tesla () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let henry  : t =
    let ptr = Capi_bindings.symbolunit_create_henry () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let minute  : t =
    let ptr = Capi_bindings.symbolunit_create_minute () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let hour  : t =
    let ptr = Capi_bindings.symbolunit_create_hour () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let electronvolt  : t =
    let ptr = Capi_bindings.symbolunit_create_electronvolt () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let celsius  : t =
    let ptr = Capi_bindings.symbolunit_create_celsius () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let fahrenheit  : t =
    let ptr = Capi_bindings.symbolunit_create_fahrenheit () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let dimensionless  : t =
    let ptr = Capi_bindings.symbolunit_create_dimensionless () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let percent  : t =
    let ptr = Capi_bindings.symbolunit_create_percent () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let radian  : t =
    let ptr = Capi_bindings.symbolunit_create_radian () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kilometer  : t =
    let ptr = Capi_bindings.symbolunit_create_kilometer () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let millimeter  : t =
    let ptr = Capi_bindings.symbolunit_create_millimeter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let millivolt  : t =
    let ptr = Capi_bindings.symbolunit_create_millivolt () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kilovolt  : t =
    let ptr = Capi_bindings.symbolunit_create_kilovolt () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let milliampere  : t =
    let ptr = Capi_bindings.symbolunit_create_milliampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let microampere  : t =
    let ptr = Capi_bindings.symbolunit_create_microampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let nanoampere  : t =
    let ptr = Capi_bindings.symbolunit_create_nanoampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let picoampere  : t =
    let ptr = Capi_bindings.symbolunit_create_picoampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let millisecond  : t =
    let ptr = Capi_bindings.symbolunit_create_millisecond () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let microsecond  : t =
    let ptr = Capi_bindings.symbolunit_create_microsecond () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let nanosecond  : t =
    let ptr = Capi_bindings.symbolunit_create_nanosecond () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let picosecond  : t =
    let ptr = Capi_bindings.symbolunit_create_picosecond () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let milliohm  : t =
    let ptr = Capi_bindings.symbolunit_create_milliohm () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kiloohm  : t =
    let ptr = Capi_bindings.symbolunit_create_kiloohm () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let megaohm  : t =
    let ptr = Capi_bindings.symbolunit_create_megaohm () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let millihertz  : t =
    let ptr = Capi_bindings.symbolunit_create_millihertz () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let kilohertz  : t =
    let ptr = Capi_bindings.symbolunit_create_kilohertz () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let megahertz  : t =
    let ptr = Capi_bindings.symbolunit_create_megahertz () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let gigahertz  : t =
    let ptr = Capi_bindings.symbolunit_create_gigahertz () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let metersPerSecond  : t =
    let ptr = Capi_bindings.symbolunit_create_meters_per_second () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let metersPerSecondSquared  : t =
    let ptr = Capi_bindings.symbolunit_create_meters_per_second_squared () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let newtonMeter  : t =
    let ptr = Capi_bindings.symbolunit_create_newton_meter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let newtonsPerMeter  : t =
    let ptr = Capi_bindings.symbolunit_create_newtons_per_meter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerMeter  : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_meter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerSecond  : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_second () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let amperesPerMeter  : t =
    let ptr = Capi_bindings.symbolunit_create_amperes_per_meter () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerAmpere  : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_ampere () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let wattsPerMeterKelvin  : t =
    let ptr = Capi_bindings.symbolunit_create_watts_per_meter_kelvin () in
    Error_handling.raise_if_error ();
    new c_symbolunit ptr

  let equal (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_not_equal handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_to_json_string handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let symbol (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_symbol handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_name handle#raw in
      Error_handling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let multiplication (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_multiplication handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_symbolunit result
    )

  let division (handle : t) (other : t) : t =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_division handle#raw other#raw in
      Error_handling.raise_if_error ();
      new c_symbolunit result
    )

  let power (handle : t) (power : int) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_power handle#raw power in
      Error_handling.raise_if_error ();
      new c_symbolunit result
    )

  let withPrefix (handle : t) (prefix : string) : t =
    Error_handling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_with_prefix handle#raw (Falcon_string.of_string prefix) in
      Error_handling.raise_if_error ();
      new c_symbolunit result
    )

  let convertValueTo (handle : t) (value : float) (target : t) : float =
    Error_handling.multi_read [handle; target] (fun () ->
      let result = Capi_bindings.symbolunit_convert_value_to handle#raw value target#raw in
      Error_handling.raise_if_error ();
      result
    )

  let isCompatibleWith (handle : t) (other : t) : bool =
    Error_handling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_is_compatible_with handle#raw other#raw in
      Error_handling.raise_if_error ();
      result
    )

end