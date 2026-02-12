open Ctypes

open Falcon_core.Generic
open Falcon_core.Physics.Device_structures

(** Opaque handle for Impedances *)
class type c_impedances_t = object
  method raw : unit ptr
end

class c_impedances : unit ptr -> c_impedances_t

module Impedances : sig
  type t = c_impedances

end

module Impedances : sig
  type t = c_impedances

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListImpedance.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val pushBack : t -> Impedance.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Impedance.t
  val items : t -> ListImpedance.t
  val contains : t -> Impedance.t -> bool
  val intersection : t -> t -> t
  val index : t -> Impedance.t -> int
end