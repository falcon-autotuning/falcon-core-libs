open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for UnitSpace *)
class type c_unitspace_t = object
  method raw : unit ptr
end

class c_unitspace : unit ptr -> c_unitspace_t

module UnitSpace : sig
  type t = c_unitspace

  val copy : t -> t
  val fromjson : string -> t
  val make : Axesdiscretizer.AxesDiscretizer.t -> Domain.Domain.t -> t
  val raySpace : float -> float -> Domain.Domain.t -> t
  val cartesianSpace : Axesdouble.AxesDouble.t -> Domain.Domain.t -> t
  val cartesian1dSpace : float -> Domain.Domain.t -> t
  val cartesian2dSpace : Axesdouble.AxesDouble.t -> Domain.Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val axes : t -> Axesdiscretizer.AxesDiscretizer.t
  val domain : t -> Domain.Domain.t
  val space : t -> Farraydouble.FArrayDouble.t
  val shape : t -> Listint.ListInt.t
  val dimension : t -> int
  val compile : t -> unit
  val createArray : t -> Axesint.AxesInt.t -> Axescontrolarray.AxesControlArray.t
  val pushBack : t -> Discretizer.Discretizer.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Discretizer.Discretizer.t
  val items : t -> Discretizer.Discretizer.t -> int -> int
  val contains : t -> Discretizer.Discretizer.t -> bool
  val index : t -> Discretizer.Discretizer.t -> int
  val intersection : t -> t -> t
end