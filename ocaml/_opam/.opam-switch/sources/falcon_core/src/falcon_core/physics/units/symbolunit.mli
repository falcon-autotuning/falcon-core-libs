open Ctypes

(** Opaque handle for SymbolUnit *)
class type c_symbolunit_t = object
  method raw : unit ptr
end

class c_symbolunit : unit ptr -> c_symbolunit_t

module SymbolUnit : sig
  type t = c_symbolunit

end

module SymbolUnit : sig
  type t = c_symbolunit

  val copy : t -> t
  val fromjson : string -> t
  val meter : t
  val kilogram : t
  val second : t
  val ampere : t
  val kelvin : t
  val mole : t
  val candela : t
  val hertz : t
  val newton : t
  val pascal : t
  val joule : t
  val watt : t
  val coulomb : t
  val volt : t
  val farad : t
  val ohm : t
  val siemens : t
  val weber : t
  val tesla : t
  val henry : t
  val minute : t
  val hour : t
  val electronvolt : t
  val celsius : t
  val fahrenheit : t
  val dimensionless : t
  val percent : t
  val radian : t
  val kilometer : t
  val millimeter : t
  val millivolt : t
  val kilovolt : t
  val milliampere : t
  val microampere : t
  val nanoampere : t
  val picoampere : t
  val millisecond : t
  val microsecond : t
  val nanosecond : t
  val picosecond : t
  val milliohm : t
  val kiloohm : t
  val megaohm : t
  val millihertz : t
  val kilohertz : t
  val megahertz : t
  val gigahertz : t
  val metersPerSecond : t
  val metersPerSecondSquared : t
  val newtonMeter : t
  val newtonsPerMeter : t
  val voltsPerMeter : t
  val voltsPerSecond : t
  val amperesPerMeter : t
  val voltsPerAmpere : t
  val wattsPerMeterKelvin : t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val symbol : t -> string
  val name : t -> string
  val multiplication : t -> t -> t
  val division : t -> t -> t
  val power : t -> int -> t
  val withPrefix : t -> string -> t
  val convertValueTo : t -> float -> t -> float
  val isCompatibleWith : t -> t -> bool
end