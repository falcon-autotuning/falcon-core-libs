open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairFloatFloat *)
class type c_listpairfloatfloat_t = object
  method raw : unit ptr
end

class c_listpairfloatfloat : unit ptr -> c_listpairfloatfloat_t

module ListPairFloatFloat : sig
  type t = c_listpairfloatfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairfloatfloat.PairFloatFloat.t -> t
  val make : Pairfloatfloat.PairFloatFloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairfloatfloat.PairFloatFloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairfloatfloat.PairFloatFloat.t
  val items : t -> Pairfloatfloat.PairFloatFloat.t -> int -> int
  val contains : t -> Pairfloatfloat.PairFloatFloat.t -> bool
  val index : t -> Pairfloatfloat.PairFloatFloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end