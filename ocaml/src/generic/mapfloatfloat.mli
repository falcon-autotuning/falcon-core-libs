open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapFloatFloat *)
class type c_mapfloatfloat_t = object
  method raw : unit ptr
end

class c_mapfloatfloat : unit ptr -> c_mapfloatfloat_t

module MapFloatFloat : sig
  type t = c_mapfloatfloat

  val empty : t
  val copy : t -> t
  val make : Pairfloatfloat.PairFloatFloat.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> float -> float -> unit
  val insert : t -> float -> float -> unit
  val at : t -> float -> float
  val erase : t -> float -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> float -> bool
  val keys : t -> Listfloat.ListFloat.t
  val values : t -> Listfloat.ListFloat.t
  val items : t -> Listpairfloatfloat.ListPairFloatFloat.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end