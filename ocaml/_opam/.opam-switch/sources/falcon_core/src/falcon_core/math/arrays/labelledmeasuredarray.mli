open Ctypes

open Falcon_core.Autotuner_interfaces.Contexts
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math.Arrays
open Falcon_core.Physics.Device_structures
open Falcon_core.Physics.Units

(** Opaque handle for LabelledMeasuredArray *)
class type c_labelledmeasuredarray_t = object
  method raw : unit ptr
end

class c_labelledmeasuredarray : unit ptr -> c_labelledmeasuredarray_t

module LabelledMeasuredArray : sig
  type t = c_labelledmeasuredarray

end

module LabelledMeasuredArray : sig
  type t = c_labelledmeasuredarray

  val copy : t -> t
  val fromjson : string -> t
  val fromFarray : FArrayDouble.t -> AcquisitionContext.t -> t
  val fromMeasuredArray : MeasuredArray.t -> AcquisitionContext.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val label : t -> AcquisitionContext.t
  val connection : t -> Connection.t
  val instrumentType : t -> string
  val units : t -> SymbolUnit.t
  val size : t -> int
  val dimension : t -> int
  val shape : t -> int -> int -> int
  val data : t -> float -> int -> int
  val plusEqualsFarray : t -> FArrayDouble.t -> unit
  val plusEqualsDouble : t -> float -> unit
  val plusEqualsInt : t -> int -> unit
  val plusMeasuredArray : t -> t -> t
  val plusFarray : t -> FArrayDouble.t -> t
  val plusDouble : t -> float -> t
  val plusInt : t -> int -> t
  val minusEqualsMeasuredArray : t -> t -> unit
  val minusEqualsFarray : t -> FArrayDouble.t -> unit
  val minusEqualsDouble : t -> float -> unit
  val minusEqualsInt : t -> int -> unit
  val minusMeasuredArray : t -> MeasuredArray.t -> t
  val minusFarray : t -> FArrayDouble.t -> t
  val minusDouble : t -> float -> t
  val minusInt : t -> int -> t
  val negation : t -> t
  val timesEqualsMeasuredArray : t -> t -> t
  val timesEqualsFarray : t -> FArrayDouble.t -> t
  val timesEqualsDouble : t -> float -> unit
  val timesEqualsInt : t -> int -> unit
  val timesMeasuredArray : t -> t -> t
  val timesFarray : t -> FArrayDouble.t -> t
  val timesDouble : t -> float -> t
  val timesInt : t -> int -> t
  val dividesEqualsMeasuredArray : t -> t -> t
  val dividesEqualsFarray : t -> FArrayDouble.t -> t
  val dividesEqualsDouble : t -> float -> unit
  val dividesEqualsInt : t -> int -> unit
  val dividesMeasuredArray : t -> t -> t
  val dividesFarray : t -> FArrayDouble.t -> t
  val dividesDouble : t -> float -> t
  val dividesInt : t -> int -> t
  val pow : t -> float -> t
  val abs : t -> t
  val min : t -> float
  val minFarray : t -> FArrayDouble.t -> t
  val minMeasuredArray : t -> t -> t
  val max : t -> float
  val maxFarray : t -> FArrayDouble.t -> t
  val maxMeasuredArray : t -> t -> t
  val greaterThan : t -> float -> bool
  val lessThan : t -> float -> bool
  val removeOffset : t -> float -> unit
  val sum : t -> float
  val reshape : t -> int -> int -> t
  val where : t -> float -> ListListSizeT.t
  val flip : t -> int -> t
  val fullGradient : t -> t -> int -> int
  val gradient : t -> int -> t
  val getSumOfSquares : t -> float
  val getSummedDiffIntOfSquares : t -> int -> float
  val getSummedDiffDoubleOfSquares : t -> float -> float
  val getSummedDiffArrayOfSquares : t -> t -> float
end