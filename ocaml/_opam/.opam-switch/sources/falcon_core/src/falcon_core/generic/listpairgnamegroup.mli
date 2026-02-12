open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairGnameGroup *)
class type c_listpairgnamegroup_t = object
  method raw : unit ptr
end

class c_listpairgnamegroup : unit ptr -> c_listpairgnamegroup_t

module ListPairGnameGroup : sig
  type t = c_listpairgnamegroup

end

module ListPairGnameGroup : sig
  type t = c_listpairgnamegroup

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairGnameGroup.t -> t
  val make : PairGnameGroup.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairGnameGroup.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairGnameGroup.t
  val items : t -> PairGnameGroup.t -> int -> int
  val contains : t -> PairGnameGroup.t -> bool
  val index : t -> PairGnameGroup.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end