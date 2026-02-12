open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListImpedance *)
class type c_listimpedance_t = object
  method raw : unit ptr
end

class c_listimpedance : unit ptr -> c_listimpedance_t

module ListImpedance : sig
  type t = c_listimpedance

  val empty : t
  val copy : t -> t
  val fillValue : int -> Impedance.Impedance.t -> t
  val make : Impedance.Impedance.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Impedance.Impedance.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Impedance.Impedance.t
  val items : t -> Impedance.Impedance.t -> int -> int
  val contains : t -> Impedance.Impedance.t -> bool
  val index : t -> Impedance.Impedance.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end