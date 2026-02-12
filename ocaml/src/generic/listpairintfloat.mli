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
  val fillValue : int -> Pairintfloat.t -> t
  val make : Pairintfloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairintfloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairintfloat.t
  val items : t -> Pairintfloat.t -> int -> int
  val contains : t -> Pairintfloat.t -> bool
  val index : t -> Pairintfloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end