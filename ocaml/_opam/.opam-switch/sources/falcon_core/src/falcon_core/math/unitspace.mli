open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math.Discrete_spaces
open Falcon_core.Math.Domains

(** Opaque handle for UnitSpace *)
class type c_unitspace_t = object
  method raw : unit ptr
end

class c_unitspace : unit ptr -> c_unitspace_t

module UnitSpace : sig
  type t = c_unitspace

end

module UnitSpace : sig
  type t = c_unitspace

  val copy : t -> t
  val fromjson : string -> t
  val make : AxesDiscretizer.t -> Domain.t -> t
  val raySpace : float -> float -> Domain.t -> t
  val cartesianSpace : AxesDouble.t -> Domain.t -> t
  val cartesian1dSpace : float -> Domain.t -> t
  val cartesian2dSpace : AxesDouble.t -> Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val axes : t -> AxesDiscretizer.t
  val domain : t -> Domain.t
  val space : t -> FArrayDouble.t
  val shape : t -> ListInt.t
  val dimension : t -> int
  val compile : t -> unit
  val createArray : t -> AxesInt.t -> AxesControlArray.t
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
end