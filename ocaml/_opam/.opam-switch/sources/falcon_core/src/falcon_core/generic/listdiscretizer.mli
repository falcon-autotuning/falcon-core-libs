open Ctypes

open Falcon_core.Math.Discrete_spaces

(** Opaque handle for ListDiscretizer *)
class type c_listdiscretizer_t = object
  method raw : unit ptr
end

class c_listdiscretizer : unit ptr -> c_listdiscretizer_t

module ListDiscretizer : sig
  type t = c_listdiscretizer

end

module ListDiscretizer : sig
  type t = c_listdiscretizer

  val empty : t
  val copy : t -> t
  val fillValue : int -> Discretizer.t -> t
  val make : Discretizer.t -> int -> t
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