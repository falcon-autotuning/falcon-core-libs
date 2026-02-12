open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic

(** Opaque handle for MeasuredArray *)
class type c_measuredarray_t = object
  method raw : unit ptr
end

class c_measuredarray : unit ptr -> c_measuredarray_t

module MeasuredArray : sig
  type t = c_measuredarray

end

module MeasuredArray : sig
  type t = c_measuredarray

  val copy : t -> t
  val fromjson : string -> t
  val fromData : float -> int -> int -> t
  val fromFarray : FArrayDouble.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
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
  val minusEqualsFarray : t -> FArrayDouble.t -> unit
  val minusEqualsDouble : t -> float -> unit
  val minusEqualsInt : t -> int -> unit
  val minusMeasuredArray : t -> t -> t
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