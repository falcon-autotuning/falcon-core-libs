open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PortTransform *)
class type c_porttransform_t = object
  method raw : unit ptr
end

class c_porttransform : unit ptr -> c_porttransform_t

module PortTransform : sig
  type t = c_porttransform

  val copy : t -> t
  val fromjson : string -> t
  val make : Instrumentport.t -> Analyticfunction.t -> t
  val constantTransform : Instrumentport.t -> float -> t
  val identityTransform : Instrumentport.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val port : t -> Instrumentport.t
  val labels : t -> string
  val evaluate : t -> Mapstringdouble.t -> float -> float
  val evaluateArraywise : t -> Mapstringdouble.t -> float -> float -> Farraydouble.t
end