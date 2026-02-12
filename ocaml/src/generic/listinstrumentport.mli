open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListInstrumentPort *)
class type c_listinstrumentport_t = object
  method raw : unit ptr
end

class c_listinstrumentport : unit ptr -> c_listinstrumentport_t

module ListInstrumentPort : sig
  type t = c_listinstrumentport

  val empty : t
  val copy : t -> t
  val fillValue : int -> Instrumentport.t -> t
  val make : Instrumentport.t -> int -> t
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