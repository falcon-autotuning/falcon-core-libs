open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapStringString *)
class type c_mapstringstring_t = object
  method raw : unit ptr
end

class c_mapstringstring : unit ptr -> c_mapstringstring_t

module MapStringString : sig
  type t = c_mapstringstring

  val empty : t
  val copy : string -> t
  val make : string -> int -> t
  val fromjson : string -> t
  val insertOrAssign : string -> string -> string -> unit
  val insert : string -> string -> string -> unit
  val at : string -> string -> string
  val erase : string -> string -> unit
  val size : string -> int
  val empty : string -> bool
  val clear : string -> unit
  val contains : string -> string -> bool
  val keys : string -> string
  val values : string -> string
  val items : string -> string
  val equal : string -> string -> bool
  val notEqual : string -> string -> bool
  val toJsonString : string -> string
end