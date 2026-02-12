open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapIntInt *)
class type c_mapintint_t = object
  method raw : unit ptr
end

class c_mapintint : unit ptr -> c_mapintint_t

module MapIntInt : sig
  type t = c_mapintint

  val empty : t
  val copy : t -> t
  val make : Pairintint.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> int -> int -> unit
  val insert : t -> int -> int -> unit
  val at : t -> int -> int
  val erase : t -> int -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> int -> bool
  val keys : t -> Listint.t
  val values : t -> Listint.t
  val items : t -> Listpairintint.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end