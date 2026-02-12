open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesInstrumentPort *)
class type c_axesinstrumentport_t = object
  method raw : unit ptr
end

class c_axesinstrumentport : unit ptr -> c_axesinstrumentport_t

module AxesInstrumentPort : sig
  type t = c_axesinstrumentport

  val empty : t
  val copy : t -> t
  val make : Listinstrumentport.t -> t
  val fromjson : string -> t
  val pushBack : t -> Instrumentport.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Instrumentport.t
  val items : t -> Instrumentport.t -> int -> int
  val contains : t -> Instrumentport.t -> bool
  val index : t -> Instrumentport.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end