open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairIntInt *)
class type c_listpairintint_t = object
  method raw : unit ptr
end

class c_listpairintint : unit ptr -> c_listpairintint_t

module ListPairIntInt : sig
  type t = c_listpairintint

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairintint.t -> t
  val make : Pairintint.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairintint.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairintint.t
  val items : t -> Pairintint.t -> int -> int
  val contains : t -> Pairintint.t -> bool
  val index : t -> Pairintint.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end