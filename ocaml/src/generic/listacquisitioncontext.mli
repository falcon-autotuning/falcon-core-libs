open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListAcquisitionContext *)
class type c_listacquisitioncontext_t = object
  method raw : unit ptr
end

class c_listacquisitioncontext : unit ptr -> c_listacquisitioncontext_t

module ListAcquisitionContext : sig
  type t = c_listacquisitioncontext

  val empty : t
  val copy : t -> t
  val fillValue : int -> Acquisitioncontext.t -> t
  val make : Acquisitioncontext.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Acquisitioncontext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Acquisitioncontext.t
  val items : t -> Acquisitioncontext.t -> int -> int
  val contains : t -> Acquisitioncontext.t -> bool
  val index : t -> Acquisitioncontext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end