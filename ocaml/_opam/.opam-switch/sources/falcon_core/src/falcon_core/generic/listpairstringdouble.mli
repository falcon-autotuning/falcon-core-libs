open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairStringDouble *)
class type c_listpairstringdouble_t = object
  method raw : unit ptr
end

class c_listpairstringdouble : unit ptr -> c_listpairstringdouble_t

module ListPairStringDouble : sig
  type t = c_listpairstringdouble

end

module ListPairStringDouble : sig
  type t = c_listpairstringdouble

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairStringDouble.t -> t
  val make : PairStringDouble.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairStringDouble.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairStringDouble.t
  val items : t -> PairStringDouble.t -> int -> int
  val contains : t -> PairStringDouble.t -> bool
  val index : t -> PairStringDouble.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end