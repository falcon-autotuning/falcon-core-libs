open Ctypes

open Falcon_core.Math.Domains

(** Opaque handle for ListLabelledDomain *)
class type c_listlabelleddomain_t = object
  method raw : unit ptr
end

class c_listlabelleddomain : unit ptr -> c_listlabelleddomain_t

module ListLabelledDomain : sig
  type t = c_listlabelleddomain

end

module ListLabelledDomain : sig
  type t = c_listlabelleddomain

  val empty : t
  val copy : t -> t
  val fillValue : int -> LabelledDomain.t -> t
  val make : LabelledDomain.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> LabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> LabelledDomain.t
  val items : t -> LabelledDomain.t -> int -> int
  val contains : t -> LabelledDomain.t -> bool
  val index : t -> LabelledDomain.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end