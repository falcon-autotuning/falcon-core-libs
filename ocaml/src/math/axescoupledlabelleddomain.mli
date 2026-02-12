open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for AxesCoupledLabelledDomain *)
class type c_axescoupledlabelleddomain_t = object
  method raw : unit ptr
end

class c_axescoupledlabelleddomain : unit ptr -> c_axescoupledlabelleddomain_t

module AxesCoupledLabelledDomain : sig
  type t = c_axescoupledlabelleddomain

  val empty : t
  val copy : t -> t
  val make : Listcoupledlabelleddomain.ListCoupledLabelledDomain.t -> t
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