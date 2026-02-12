open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Domain *)
class type c_domain_t = object
  method raw : unit ptr
end

class c_domain : unit ptr -> c_domain_t

module Domain : sig
  type t = c_domain

  val copy : t -> t
  val fromjson : string -> t
  val make : float -> float -> bool -> bool -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val lesserBound : t -> float
  val greaterBound : t -> float
  val lesserBoundContained : t -> bool
  val greaterBoundContained : t -> bool
  val in_ : t -> float -> bool
  val range : t -> float
  val center : t -> float
  val intersection : t -> t -> t
  val union : t -> t -> t
  val isEmpty : t -> bool
  val containsDomain : t -> t -> bool
  val shift : t -> float -> t
  val scale : t -> float -> t
  val transform : t -> t -> float -> float
end