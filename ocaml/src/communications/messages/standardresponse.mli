open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for StandardResponse *)
class type c_standardresponse_t = object
  method raw : unit ptr
end

class c_standardresponse : unit ptr -> c_standardresponse_t

module StandardResponse : sig
  type t = c_standardresponse

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val message : t -> string
end