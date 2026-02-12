open Ctypes

open Falcon_core.Autotuner_interfaces.Contexts
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Physics.Units

(** Opaque handle for InterpretationContext *)
class type c_interpretationcontext_t = object
  method raw : unit ptr
end

class c_interpretationcontext : unit ptr -> c_interpretationcontext_t

module InterpretationContext : sig
  type t = c_interpretationcontext

end

module InterpretationContext : sig
  type t = c_interpretationcontext

  val copy : t -> t
  val fromjson : string -> t
  val make : AxesMeasurementContext.t -> ListMeasurementContext.t -> SymbolUnit.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val independentVariables : t -> AxesMeasurementContext.t
  val dependentVariables : t -> ListMeasurementContext.t
  val unit : t -> SymbolUnit.t
  val dimension : t -> int
  val addDependentVariable : t -> MeasurementContext.t -> unit
  val replaceDependentVariable : t -> int -> MeasurementContext.t -> unit
  val getIndependentVariables : t -> int -> MeasurementContext.t
  val withUnit : t -> SymbolUnit.t -> t
end