open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListListSizeT *)
class type c_listlistsizet_t = object
  method raw : unit ptr
end

class c_listlistsizet : unit ptr -> c_listlistsizet_t

module ListListSizeT : sig
  type t = c_listlistsizet

  val empty : t
  val copy : t -> t
  val fillValue : int -> Listsizet.ListSizeT.t -> t
  val make : Listsizet.ListSizeT.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Listsizet.ListSizeT.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Listsizet.ListSizeT.t
  val items : t -> Listsizet.ListSizeT.t -> int -> int
  val contains : t -> Listsizet.ListSizeT.t -> bool
  val index : t -> Listsizet.ListSizeT.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end