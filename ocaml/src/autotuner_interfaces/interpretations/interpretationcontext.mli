open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for InterpretationContext *)
class type c_interpretationcontext_t = object
  method raw : unit ptr
end

class c_interpretationcontext : unit ptr -> c_interpretationcontext_t

module InterpretationContext : sig
  type t = c_interpretationcontext

  val copy : t -> t
  val fromjson : string -> t
  val make : Axesmeasurementcontext.AxesMeasurementContext.t -> Listmeasurementcontext.ListMeasurementContext.t -> Symbolunit.SymbolUnit.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val independentVariables : t -> Axesmeasurementcontext.AxesMeasurementContext.t
  val dependentVariables : t -> Listmeasurementcontext.ListMeasurementContext.t
  val unit : t -> Symbolunit.SymbolUnit.t
  val dimension : t -> int
  val addDependentVariable : t -> Measurementcontext.MeasurementContext.t -> unit
  val replaceDependentVariable : t -> int -> Measurementcontext.MeasurementContext.t -> unit
  val getIndependentVariables : t -> int -> Measurementcontext.MeasurementContext.t
  val withUnit : t -> Symbolunit.SymbolUnit.t -> t
end