open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for FArrayDouble *)
class type c_farraydouble_t = object
  method raw : unit ptr
end

class c_farraydouble : unit ptr -> c_farraydouble_t

module FArrayDouble : sig
  type t = c_farraydouble

  val empty : int -> int -> t
  val copy : t -> t
  val zeros : int -> int -> t
  val fromShape : int -> int -> t
  val fromData : float -> int -> int -> t
  val fromjson : string -> t
  val size : t -> int
  val dimension : t -> int
  val shape : t -> int -> int -> int
  val data : t -> float -> int -> int
  val plusEqualsFarray : t -> t -> unit
  val plusEqualsDouble : t -> float -> unit
  val plusEqualsInt : t -> int -> unit
  val plusFarray : t -> t -> t
  val plusDouble : t -> float -> t
  val plusInt : t -> int -> t
  val minusEqualsFarray : t -> t -> unit
  val minusEqualsDouble : t -> float -> unit
  val minusEqualsInt : t -> int -> unit
  val minusFarray : t -> t -> t
  val minusDouble : t -> float -> t
  val minusInt : t -> int -> t
  val negation : t -> t
  val timesEqualsFarray : t -> t -> unit
  val timesEqualsDouble : t -> float -> unit
  val timesEqualsInt : t -> int -> unit
  val timesFarray : t -> t -> t
  val timesDouble : t -> float -> t
  val timesInt : t -> int -> t
  val dividesEqualsFarray : t -> t -> unit
  val dividesEqualsDouble : t -> float -> unit
  val dividesEqualsInt : t -> int -> unit
  val dividesFarray : t -> t -> t
  val dividesDouble : t -> float -> t
  val dividesInt : t -> int -> t
  val pow : t -> float -> t
  val doublePow : t -> float -> t
  val powInplace : t -> float -> unit
  val abs : t -> t
  val min : t -> float
  val minArraywise : t -> t -> t
  val max : t -> float
  val maxArraywise : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val greaterThan : t -> float -> bool
  val lessThan : t -> float -> bool
  val removeOffset : t -> float -> unit
  val sum : t -> float
  val reshape : t -> int -> int -> t
  val where : t -> float -> Listlistsizet.t
  val flip : t -> int -> t
  val fullGradient : t -> t -> int -> int
  val gradient : t -> int -> t
  val getSumOfSquares : t -> float
  val getSummedDiffIntOfSquares : t -> int -> float
  val getSummedDiffDoubleOfSquares : t -> float -> float
  val getSummedDiffArrayOfSquares : t -> t -> float
  val toJsonString : t -> string
end