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
  val make : Listlabelleddomain.ListLabelledDomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val domains : t -> Listlabelleddomain.ListLabelledDomain.t
  val labels : t -> Ports.Ports.t
  val getDomain : t -> Instrumentport.InstrumentPort.t -> Labelleddomain.LabelledDomain.t
  val intersection : t -> t -> t
  val pushBack : t -> Labelleddomain.LabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val constAt : t -> int -> Labelleddomain.LabelledDomain.t
  val at : t -> int -> Labelleddomain.LabelledDomain.t
  val items : t -> Listlabelleddomain.ListLabelledDomain.t
  val contains : t -> Labelleddomain.LabelledDomain.t -> bool
  val index : t -> Labelleddomain.LabelledDomain.t -> int
end