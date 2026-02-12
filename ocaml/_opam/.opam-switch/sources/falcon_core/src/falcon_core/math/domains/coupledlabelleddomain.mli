open Ctypes

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Instrument_interfaces.Names
open Falcon_core.Math.Domains

(** Opaque handle for CoupledLabelledDomain *)
class type c_coupledlabelleddomain_t = object
  method raw : unit ptr
end

class c_coupledlabelleddomain : unit ptr -> c_coupledlabelleddomain_t

module CoupledLabelledDomain : sig
  type t = c_coupledlabelleddomain

end

module CoupledLabelledDomain : sig
  type t = c_coupledlabelleddomain

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListLabelledDomain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val domains : t -> ListLabelledDomain.t
  val labels : t -> Ports.t
  val getDomain : t -> InstrumentPort.t -> LabelledDomain.t
  val intersection : t -> t -> t
  val pushBack : t -> LabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val constAt : t -> int -> LabelledDomain.t
  val at : t -> int -> LabelledDomain.t
  val items : t -> ListLabelledDomain.t
  val contains : t -> LabelledDomain.t -> bool
  val index : t -> LabelledDomain.t -> int
end