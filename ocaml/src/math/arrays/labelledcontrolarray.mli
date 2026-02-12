open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for LabelledControlArray *)
class type c_labelledcontrolarray_t = object
  method raw : unit ptr
end

class c_labelledcontrolarray : unit ptr -> c_labelledcontrolarray_t

module LabelledControlArray : sig
  type t = c_labelledcontrolarray

  val copy : t -> t
  val fromjson : string -> t
  val fromFarray : Farraydouble.FArrayDouble.t -> Acquisitioncontext.AcquisitionContext.t -> t
  val fromControlArray : Controlarray.ControlArray.t -> Acquisitioncontext.AcquisitionContext.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val label : t -> Acquisitioncontext.AcquisitionContext.t
  val connection : t -> Connection.Connection.t
  val instrumentType : t -> string
  val units : t -> Symbolunit.SymbolUnit.t
  val size : t -> int
  val dimension : t -> int
  val shape : t -> int -> int -> int
  val data : t -> float -> int -> int
  val plusEqualsFarray : t -> Farraydouble.FArrayDouble.t -> unit
  val plusEqualsDouble : t -> float -> unit
  val plusEqualsInt : t -> int -> unit
  val plusControlArray : t -> t -> t
  val plusFarray : t -> Farraydouble.FArrayDouble.t -> t
  val plusDouble : t -> float -> t
  val plusInt : t -> int -> t
  val minusEqualsControlArray : t -> t -> unit
  val minusEqualsFarray : t -> Farraydouble.FArrayDouble.t -> unit
  val minusEqualsDouble : t -> float -> unit
  val minusEqualsInt : t -> int -> unit
  val minusControlArray : t -> t -> t
  val minusFarray : t -> Farraydouble.FArrayDouble.t -> t
  val minusDouble : t -> float -> t
  val minusInt : t -> int -> t
  val negation : t -> t
  val timesEqualsDouble : t -> float -> unit
  val timesEqualsInt : t -> int -> unit
  val timesDouble : t -> float -> t
  val timesInt : t -> int -> t
  val dividesEqualsDouble : t -> float -> unit
  val dividesEqualsInt : t -> int -> unit
  val dividesDouble : t -> float -> t
  val dividesInt : t -> int -> t
  val pow : t -> float -> t
  val abs : t -> t
  val min : t -> float
  val minFarray : t -> Farraydouble.FArrayDouble.t -> t
  val minControlArray : t -> t -> t
  val max : t -> float
  val maxFarray : t -> Farraydouble.FArrayDouble.t -> t
  val maxControlArray : t -> t -> t
  val greaterThan : t -> float -> bool
  val lessThan : t -> float -> bool
  val removeOffset : t -> float -> unit
  val sum : t -> float
  val where : t -> float -> Listlistsizet.ListListSizeT.t
  val flip : t -> int -> t
  val fullGradient : t -> Farraydouble.FArrayDouble.t -> int -> int
  val gradient : t -> int -> Farraydouble.FArrayDouble.t
  val getSumOfSquares : t -> float
  val getSummedDiffIntOfSquares : t -> int -> float
  val getSummedDiffDoubleOfSquares : t -> float -> float
  val getSummedDiffArrayOfSquares : t -> t -> float
end