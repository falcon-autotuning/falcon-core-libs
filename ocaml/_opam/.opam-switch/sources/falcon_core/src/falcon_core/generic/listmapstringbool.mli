open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListMapStringBool *)
class type c_listmapstringbool_t = object
  method raw : unit ptr
end

class c_listmapstringbool : unit ptr -> c_listmapstringbool_t

module ListMapStringBool : sig
  type t = c_listmapstringbool

end

module ListMapStringBool : sig
  type t = c_listmapstringbool

  val empty : t
  val copy : t -> t
  val fillValue : int -> MapStringBool.t -> t
  val make : MapStringBool.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> MapStringBool.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> MapStringBool.t
  val items : t -> MapStringBool.t -> int -> int
  val contains : t -> MapStringBool.t -> bool
  val index : t -> MapStringBool.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end