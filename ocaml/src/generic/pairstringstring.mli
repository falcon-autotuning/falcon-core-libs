open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairStringString *)
class type c_pairstringstring_t = object
  method raw : unit ptr
end

class c_pairstringstring : unit ptr -> c_pairstringstring_t

module PairStringString : sig
  type t = c_pairstringstring

  val make : string -> string -> t
  val copy : string -> t
  val fromjson : string -> t
  val first : string -> string
  val second : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end