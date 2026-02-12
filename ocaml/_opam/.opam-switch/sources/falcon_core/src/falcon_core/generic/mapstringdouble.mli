open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic

(** Opaque handle for MapStringDouble *)
class type c_mapstringdouble_t = object
  method raw : unit ptr
end

class c_mapstringdouble : unit ptr -> c_mapstringdouble_t

module MapStringDouble : sig
  type t = c_mapstringdouble

end

module MapStringDouble : sig
  type t = c_mapstringdouble

  val empty : t
  val copy : t -> t
  val make : PairStringDouble.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> string -> float -> unit
  val insert : t -> string -> float -> unit
  val at : t -> string -> float
  val erase : t -> string -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> string -> bool
  val keys : t -> string
  val values : t -> ListDouble.t
  val items : t -> ListPairStringDouble.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end