open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairFloatFloat *)
class type c_listpairfloatfloat_t = object
  method raw : unit ptr
end

class c_listpairfloatfloat : unit ptr -> c_listpairfloatfloat_t

module ListPairFloatFloat : sig
  type t = c_listpairfloatfloat

end

module ListPairFloatFloat : sig
  type t = c_listpairfloatfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairFloatFloat.t -> t
  val make : PairFloatFloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairFloatFloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairFloatFloat.t
  val items : t -> PairFloatFloat.t -> int -> int
  val contains : t -> PairFloatFloat.t -> bool
  val index : t -> PairFloatFloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end