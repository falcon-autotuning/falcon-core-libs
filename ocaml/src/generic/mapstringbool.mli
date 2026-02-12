open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapStringBool *)
class type c_mapstringbool_t = object
  method raw : unit ptr
end

class c_mapstringbool : unit ptr -> c_mapstringbool_t

module MapStringBool : sig
  type t = c_mapstringbool

  val empty : t
  val copy : t -> t
  val make : Pairstringbool.PairStringBool.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> string -> bool -> unit
  val insert : t -> string -> bool -> unit
  val at : t -> string -> bool
  val erase : t -> string -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> string -> bool
  val keys : t -> string
  val values : t -> Listbool.ListBool.t
  val items : t -> Listpairstringbool.ListPairStringBool.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end