open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for MapGnameGroup *)
class type c_mapgnamegroup_t = object
  method raw : unit ptr
end

class c_mapgnamegroup : unit ptr -> c_mapgnamegroup_t

module MapGnameGroup : sig
  type t = c_mapgnamegroup

  val empty : t
  val copy : t -> t
  val make : Pairgnamegroup.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Gname.t -> Group.t -> unit
  val insert : t -> Gname.t -> Group.t -> unit
  val at : t -> Gname.t -> Group.t
  val erase : t -> Gname.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Gname.t -> bool
  val keys : t -> Listgname.t
  val values : t -> Listgroup.t
  val items : t -> Listpairgnamegroup.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end