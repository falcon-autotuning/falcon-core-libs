open Ctypes

open Falcon_core.Autotuner_interfaces.Contexts

(** Opaque handle for ListAcquisitionContext *)
class type c_listacquisitioncontext_t = object
  method raw : unit ptr
end

class c_listacquisitioncontext : unit ptr -> c_listacquisitioncontext_t

module ListAcquisitionContext : sig
  type t = c_listacquisitioncontext

end

module ListAcquisitionContext : sig
  type t = c_listacquisitioncontext

  val empty : t
  val copy : t -> t
  val fillValue : int -> AcquisitionContext.t -> t
  val make : AcquisitionContext.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> AcquisitionContext.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> AcquisitionContext.t
  val items : t -> AcquisitionContext.t -> int -> int
  val contains : t -> AcquisitionContext.t -> bool
  val index : t -> AcquisitionContext.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end