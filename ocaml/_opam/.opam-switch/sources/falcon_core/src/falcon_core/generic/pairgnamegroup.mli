open Ctypes

open Falcon_core.Autotuner_interfaces.Names
open Falcon_core.Physics.Config.Core

(** Opaque handle for PairGnameGroup *)
class type c_pairgnamegroup_t = object
  method raw : unit ptr
end

class c_pairgnamegroup : unit ptr -> c_pairgnamegroup_t

module PairGnameGroup : sig
  type t = c_pairgnamegroup

end

module PairGnameGroup : sig
  type t = c_pairgnamegroup

  val make : Gname.t -> Group.t -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> Gname.t
  val second : t -> Group.t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end