open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Channel *)
class type c_channel_t = object
  method raw : unit ptr
end

class c_channel : unit ptr -> c_channel_t

module Channel : sig
  type t = c_channel

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val name : t -> string
end