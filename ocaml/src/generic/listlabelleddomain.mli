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
  val fillValue : int -> Labelleddomain.t -> t
  val make : Labelleddomain.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Labelleddomain.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Labelleddomain.t
  val items : t -> Labelleddomain.t -> int -> int
  val contains : t -> Labelleddomain.t -> bool
  val index : t -> Labelleddomain.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end