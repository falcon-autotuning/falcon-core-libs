open Ctypes

(** Opaque handle for PairDoubleDouble *)
class type c_pairdoubledouble_t = object
  method raw : unit ptr
end

class c_pairdoubledouble : unit ptr -> c_pairdoubledouble_t

module PairDoubleDouble : sig
  type t = c_pairdoubledouble

end

module PairDoubleDouble : sig
  type t = c_pairdoubledouble

  val make : float -> float -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> float
  val second : t -> float
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end