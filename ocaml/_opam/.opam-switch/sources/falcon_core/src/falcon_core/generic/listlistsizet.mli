open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListListSizeT *)
class type c_listlistsizet_t = object
  method raw : unit ptr
end

class c_listlistsizet : unit ptr -> c_listlistsizet_t

module ListListSizeT : sig
  type t = c_listlistsizet

end

module ListListSizeT : sig
  type t = c_listlistsizet

  val empty : t
  val copy : t -> t
  val fillValue : int -> ListSizeT.t -> t
  val make : ListSizeT.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> ListSizeT.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> ListSizeT.t
  val items : t -> ListSizeT.t -> int -> int
  val contains : t -> ListSizeT.t -> bool
  val index : t -> ListSizeT.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end