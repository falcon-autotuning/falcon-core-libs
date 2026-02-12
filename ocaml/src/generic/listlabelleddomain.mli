open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListLabelledDomain *)
class type c_listlabelleddomain_t = object
  method raw : unit ptr
end

class c_listlabelleddomain : unit ptr -> c_listlabelleddomain_t

module ListLabelledDomain : sig
  type t = c_listlabelleddomain

  val empty : t
  val copy : t -> t
  val fillValue : int -> Labelleddomain.LabelledDomain.t -> t
  val make : Labelleddomain.LabelledDomain.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Labelleddomain.LabelledDomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelleddomain.LabelledDomain.t
  val items : t -> Labelleddomain.LabelledDomain.t -> int -> int
  val contains : t -> Labelleddomain.LabelledDomain.t -> bool
  val index : t -> Labelleddomain.LabelledDomain.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end