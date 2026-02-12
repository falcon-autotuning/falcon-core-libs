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
  val make : Pairgnamegroup.PairGnameGroup.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Gname.Gname.t -> Group.Group.t -> unit
  val insert : t -> Gname.Gname.t -> Group.Group.t -> unit
  val at : t -> Gname.Gname.t -> Group.Group.t
  val erase : t -> Gname.Gname.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Gname.Gname.t -> bool
  val keys : t -> Listgname.ListGname.t
  val values : t -> Listgroup.ListGroup.t
  val items : t -> Listpairgnamegroup.ListPairGnameGroup.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end