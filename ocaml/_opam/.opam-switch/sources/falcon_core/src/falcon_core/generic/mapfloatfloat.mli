open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic

(** Opaque handle for MapFloatFloat *)
class type c_mapfloatfloat_t = object
  method raw : unit ptr
end

class c_mapfloatfloat : unit ptr -> c_mapfloatfloat_t

module MapFloatFloat : sig
  type t = c_mapfloatfloat

end

module MapFloatFloat : sig
  type t = c_mapfloatfloat

  val empty : t
  val copy : t -> t
  val make : PairFloatFloat.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> float -> float -> unit
  val insert : t -> float -> float -> unit
  val at : t -> float -> float
  val erase : t -> float -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> float -> bool
  val keys : t -> ListFloat.t
  val values : t -> ListFloat.t
  val items : t -> ListPairFloatFloat.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end