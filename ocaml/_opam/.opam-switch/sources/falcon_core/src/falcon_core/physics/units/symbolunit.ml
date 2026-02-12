open Ctypes
open Capi_bindings
open ErrorHandling

(* no extra imports *)

class c_symbolunit (h : unit ptr) = object(self)
  val raw_val = h
  method raw = raw_val
  initializer Gc.finalise (fun _ ->
    Capi_bindings.symbolunit_destroy raw_val;
    ErrorHandling.raise_if_error ()
  ) self
end

module SymbolUnit = struct
  type t = c_symbolunit

  let copy (handle : t) : t =
    ErrorHandling.read handle (fun () ->
      let ptr = Capi_bindings.symbolunit_copy handle#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit ptr
    )

  let fromjson (json : string) : t =
    let ptr = Capi_bindings.symbolunit_from_json_string (Capi_bindings.string_wrap json) in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let meter () : t =
    let ptr = Capi_bindings.symbolunit_create_meter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kilogram () : t =
    let ptr = Capi_bindings.symbolunit_create_kilogram () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let second () : t =
    let ptr = Capi_bindings.symbolunit_create_second () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let ampere () : t =
    let ptr = Capi_bindings.symbolunit_create_ampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kelvin () : t =
    let ptr = Capi_bindings.symbolunit_create_kelvin () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let mole () : t =
    let ptr = Capi_bindings.symbolunit_create_mole () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let candela () : t =
    let ptr = Capi_bindings.symbolunit_create_candela () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let hertz () : t =
    let ptr = Capi_bindings.symbolunit_create_hertz () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let newton () : t =
    let ptr = Capi_bindings.symbolunit_create_newton () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let pascal () : t =
    let ptr = Capi_bindings.symbolunit_create_pascal () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let joule () : t =
    let ptr = Capi_bindings.symbolunit_create_joule () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let watt () : t =
    let ptr = Capi_bindings.symbolunit_create_watt () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let coulomb () : t =
    let ptr = Capi_bindings.symbolunit_create_coulomb () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let volt () : t =
    let ptr = Capi_bindings.symbolunit_create_volt () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let farad () : t =
    let ptr = Capi_bindings.symbolunit_create_farad () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let ohm () : t =
    let ptr = Capi_bindings.symbolunit_create_ohm () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let siemens () : t =
    let ptr = Capi_bindings.symbolunit_create_siemens () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let weber () : t =
    let ptr = Capi_bindings.symbolunit_create_weber () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let tesla () : t =
    let ptr = Capi_bindings.symbolunit_create_tesla () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let henry () : t =
    let ptr = Capi_bindings.symbolunit_create_henry () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let minute () : t =
    let ptr = Capi_bindings.symbolunit_create_minute () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let hour () : t =
    let ptr = Capi_bindings.symbolunit_create_hour () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let electronvolt () : t =
    let ptr = Capi_bindings.symbolunit_create_electronvolt () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let celsius () : t =
    let ptr = Capi_bindings.symbolunit_create_celsius () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let fahrenheit () : t =
    let ptr = Capi_bindings.symbolunit_create_fahrenheit () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let dimensionless () : t =
    let ptr = Capi_bindings.symbolunit_create_dimensionless () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let percent () : t =
    let ptr = Capi_bindings.symbolunit_create_percent () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let radian () : t =
    let ptr = Capi_bindings.symbolunit_create_radian () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kilometer () : t =
    let ptr = Capi_bindings.symbolunit_create_kilometer () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let millimeter () : t =
    let ptr = Capi_bindings.symbolunit_create_millimeter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let millivolt () : t =
    let ptr = Capi_bindings.symbolunit_create_millivolt () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kilovolt () : t =
    let ptr = Capi_bindings.symbolunit_create_kilovolt () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let milliampere () : t =
    let ptr = Capi_bindings.symbolunit_create_milliampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let microampere () : t =
    let ptr = Capi_bindings.symbolunit_create_microampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let nanoampere () : t =
    let ptr = Capi_bindings.symbolunit_create_nanoampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let picoampere () : t =
    let ptr = Capi_bindings.symbolunit_create_picoampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let millisecond () : t =
    let ptr = Capi_bindings.symbolunit_create_millisecond () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let microsecond () : t =
    let ptr = Capi_bindings.symbolunit_create_microsecond () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let nanosecond () : t =
    let ptr = Capi_bindings.symbolunit_create_nanosecond () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let picosecond () : t =
    let ptr = Capi_bindings.symbolunit_create_picosecond () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let milliohm () : t =
    let ptr = Capi_bindings.symbolunit_create_milliohm () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kiloohm () : t =
    let ptr = Capi_bindings.symbolunit_create_kiloohm () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let megaohm () : t =
    let ptr = Capi_bindings.symbolunit_create_megaohm () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let millihertz () : t =
    let ptr = Capi_bindings.symbolunit_create_millihertz () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let kilohertz () : t =
    let ptr = Capi_bindings.symbolunit_create_kilohertz () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let megahertz () : t =
    let ptr = Capi_bindings.symbolunit_create_megahertz () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let gigahertz () : t =
    let ptr = Capi_bindings.symbolunit_create_gigahertz () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let metersPerSecond () : t =
    let ptr = Capi_bindings.symbolunit_create_meters_per_second () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let metersPerSecondSquared () : t =
    let ptr = Capi_bindings.symbolunit_create_meters_per_second_squared () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let newtonMeter () : t =
    let ptr = Capi_bindings.symbolunit_create_newton_meter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let newtonsPerMeter () : t =
    let ptr = Capi_bindings.symbolunit_create_newtons_per_meter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerMeter () : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_meter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerSecond () : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_second () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let amperesPerMeter () : t =
    let ptr = Capi_bindings.symbolunit_create_amperes_per_meter () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let voltsPerAmpere () : t =
    let ptr = Capi_bindings.symbolunit_create_volts_per_ampere () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let wattsPerMeterKelvin () : t =
    let ptr = Capi_bindings.symbolunit_create_watts_per_meter_kelvin () in
    ErrorHandling.raise_if_error ();
    new c_symbolunit ptr

  let equal (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let notEqual (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_not_equal handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let toJsonString (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_to_json_string handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let symbol (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_symbol handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let name (handle : t) : string =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_name handle#raw in
      ErrorHandling.raise_if_error ();
      Capi_bindings.string_to_ocaml result
    )

  let multiplication (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_multiplication handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let division (handle : t) (other : t) : t =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_division handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let power (handle : t) (power : int) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_power handle#raw power in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let withPrefix (handle : t) (prefix : string) : t =
    ErrorHandling.read handle (fun () ->
      let result = Capi_bindings.symbolunit_with_prefix handle#raw (Capi_bindings.string_wrap prefix) in
      ErrorHandling.raise_if_error ();
      new c_symbolunit result
    )

  let convertValueTo (handle : t) (value : float) (target : t) : float =
    ErrorHandling.multi_read [handle; target] (fun () ->
      let result = Capi_bindings.symbolunit_convert_value_to handle#raw value target#raw in
      ErrorHandling.raise_if_error ();
      result
    )

  let isCompatibleWith (handle : t) (other : t) : bool =
    ErrorHandling.multi_read [handle; other] (fun () ->
      let result = Capi_bindings.symbolunit_is_compatible_with handle#raw other#raw in
      ErrorHandling.raise_if_error ();
      result
    )

end