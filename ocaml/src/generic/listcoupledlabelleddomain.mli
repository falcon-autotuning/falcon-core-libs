open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListCoupledLabelledDomain *)
class type c_listcoupledlabelleddomain_t = object
  method raw : unit ptr
end

class c_listcoupledlabelleddomain : unit ptr -> c_listcoupledlabelleddomain_t

module ListCoupledLabelledDomain : sig
  type t = c_listcoupledlabelleddomain

  val empty : t
  val copy : t -> t
  val fillValue : int -> Coupledlabelleddomain.CoupledLabelledDomain.t -> t
  val make : Coupledlabelleddomain.CoupledLabelledDomain.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Coupledlabelleddomain.CoupledLabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Coupledlabelleddomain.CoupledLabelledDomain.t
  val items : t -> Coupledlabelleddomain.CoupledLabelledDomain.t -> int -> int
  val contains : t -> Coupledlabelleddomain.CoupledLabelledDomain.t -> bool
  val index : t -> Coupledlabelleddomain.CoupledLabelledDomain.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end