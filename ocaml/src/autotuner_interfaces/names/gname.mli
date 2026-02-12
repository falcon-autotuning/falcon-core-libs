open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Gname *)
class type c_gname_t = object
  method raw : unit ptr
end

class c_gname : unit ptr -> c_gname_t

module Gname : sig
  type t = c_gname

  val copy : t -> t
  val fromjson : string -> t
  val fromNum : int -> t
  val make : string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val gname : t -> string
end