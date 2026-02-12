open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListMapStringBool *)
class type c_listmapstringbool_t = object
  method raw : unit ptr
end

class c_listmapstringbool : unit ptr -> c_listmapstringbool_t

module ListMapStringBool : sig
  type t = c_listmapstringbool

  val empty : t
  val copy : t -> t
  val fillValue : int -> Mapstringbool.t -> t
  val make : Mapstringbool.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Mapstringbool.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Mapstringbool.t
  val items : t -> Mapstringbool.t -> int -> int
  val contains : t -> Mapstringbool.t -> bool
  val index : t -> Mapstringbool.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end