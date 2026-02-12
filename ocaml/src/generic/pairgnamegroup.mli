open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for PairGnameGroup *)
class type c_pairgnamegroup_t = object
  method raw : unit ptr
end

class c_pairgnamegroup : unit ptr -> c_pairgnamegroup_t

module PairGnameGroup : sig
  type t = c_pairgnamegroup

  val make : Gname.Gname.t -> Group.Group.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Gname.Gname.t
  val second : t -> Group.Group.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end