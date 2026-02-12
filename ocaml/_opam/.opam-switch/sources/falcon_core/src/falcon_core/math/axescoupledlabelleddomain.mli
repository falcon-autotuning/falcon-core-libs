open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Domains

(** Opaque handle for AxesCoupledLabelledDomain *)
class type c_axescoupledlabelleddomain_t = object
  method raw : unit ptr
end

class c_axescoupledlabelleddomain : unit ptr -> c_axescoupledlabelleddomain_t

module AxesCoupledLabelledDomain : sig
  type t = c_axescoupledlabelleddomain

end

module AxesCoupledLabelledDomain : sig
  type t = c_axescoupledlabelleddomain

  val empty : t
  val copy : t -> t
  val make : ListCoupledLabelledDomain.t -> t
  val fromjson : string -> t
  val pushBack : t -> CoupledLabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> CoupledLabelledDomain.t
  val items : t -> CoupledLabelledDomain.t -> int -> int
  val contains : t -> CoupledLabelledDomain.t -> bool
  val index : t -> CoupledLabelledDomain.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end