open Ctypes

open Falcon_core.Generic
open Falcon_core.Math.Discrete_spaces

(** Opaque handle for AxesDiscretizer *)
class type c_axesdiscretizer_t = object
  method raw : unit ptr
end

class c_axesdiscretizer : unit ptr -> c_axesdiscretizer_t

module AxesDiscretizer : sig
  type t = c_axesdiscretizer

end

module AxesDiscretizer : sig
  type t = c_axesdiscretizer

  val empty : t
  val copy : t -> t
  val make : ListDiscretizer.t -> t
  val fromjson : string -> t
  val pushBack : t -> Discretizer.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Discretizer.t
  val items : t -> Discretizer.t -> int -> int
  val contains : t -> Discretizer.t -> bool
  val index : t -> Discretizer.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end