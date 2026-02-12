open Ctypes

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Physics.Config.Core

(** Opaque handle for MapGnameGroup *)
class type c_mapgnamegroup_t = object
  method raw : unit ptr
end

class c_mapgnamegroup : unit ptr -> c_mapgnamegroup_t

module MapGnameGroup : sig
  type t = c_mapgnamegroup

end

module MapGnameGroup : sig
  type t = c_mapgnamegroup

  val empty : t
  val copy : t -> t
  val make : PairGnameGroup.t -> int -> t
  val fromjson : string -> t
  val insertOrAssign : t -> Gname.t -> Group.t -> unit
  val insert : t -> Gname.t -> Group.t -> unit
  val at : t -> Gname.t -> Group.t
  val erase : t -> Gname.t -> unit
  val size : t -> int
  val empty : t -> bool
  val clear : t -> unit
  val contains : t -> Gname.t -> bool
  val keys : t -> ListGname.t
  val values : t -> ListGroup.t
  val items : t -> ListPairGnameGroup.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end