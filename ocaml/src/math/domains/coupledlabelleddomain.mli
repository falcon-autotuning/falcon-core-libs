open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for CoupledLabelledDomain *)
class type c_coupledlabelleddomain_t = object
  method raw : unit ptr
end

class c_coupledlabelleddomain : unit ptr -> c_coupledlabelleddomain_t

module CoupledLabelledDomain : sig
  type t = c_coupledlabelleddomain

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listlabelleddomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val domains : t -> Listlabelleddomain.t
  val labels : t -> Ports.t
  val getDomain : t -> Instrumentport.t -> Labelleddomain.t
  val intersection : t -> t -> t
  val pushBack : t -> Labelleddomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val constAt : t -> int -> Labelleddomain.t
  val at : t -> int -> Labelleddomain.t
  val items : t -> Listlabelleddomain.t
  val contains : t -> Labelleddomain.t -> bool
  val index : t -> Labelleddomain.t -> int
end