open Ctypes

open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Port_transforms

(** Opaque handle for PortTransforms *)
class type c_porttransforms_t = object
  method raw : unit ptr
end

class c_porttransforms : unit ptr -> c_porttransforms_t

module PortTransforms : sig
  type t = c_porttransforms

end

module PortTransforms : sig
  type t = c_porttransforms

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : ListPortTransform.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val transforms : t -> ListPortTransform.t
  val pushBack : t -> PortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PortTransform.t
  val items : t -> ListPortTransform.t
  val contains : t -> PortTransform.t -> bool
  val index : t -> PortTransform.t -> int
  val intersection : t -> t -> t
end