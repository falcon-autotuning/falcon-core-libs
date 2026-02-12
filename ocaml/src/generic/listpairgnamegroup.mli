open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairGnameGroup *)
class type c_listpairgnamegroup_t = object
  method raw : unit ptr
end

class c_listpairgnamegroup : unit ptr -> c_listpairgnamegroup_t

module ListPairGnameGroup : sig
  type t = c_listpairgnamegroup

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairgnamegroup.t -> t
  val make : Pairgnamegroup.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairgnamegroup.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairgnamegroup.t
  val items : t -> Pairgnamegroup.t -> int -> int
  val contains : t -> Pairgnamegroup.t -> bool
  val index : t -> Pairgnamegroup.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end