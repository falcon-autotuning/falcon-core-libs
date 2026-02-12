open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairIntFloat *)
class type c_listpairintfloat_t = object
  method raw : unit ptr
end

class c_listpairintfloat : unit ptr -> c_listpairintfloat_t

module ListPairIntFloat : sig
  type t = c_listpairintfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairintfloat.PairIntFloat.t -> t
  val make : Pairintfloat.PairIntFloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairintfloat.PairIntFloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairintfloat.PairIntFloat.t
  val items : t -> Pairintfloat.PairIntFloat.t -> int -> int
  val contains : t -> Pairintfloat.PairIntFloat.t -> bool
  val index : t -> Pairintfloat.PairIntFloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end