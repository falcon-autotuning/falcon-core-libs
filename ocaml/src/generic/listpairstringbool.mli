open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairStringBool *)
class type c_listpairstringbool_t = object
  method raw : unit ptr
end

class c_listpairstringbool : unit ptr -> c_listpairstringbool_t

module ListPairStringBool : sig
  type t = c_listpairstringbool

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairstringbool.t -> t
  val make : Pairstringbool.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairstringbool.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairstringbool.t
  val items : t -> Pairstringbool.t -> int -> int
  val contains : t -> Pairstringbool.t -> bool
  val index : t -> Pairstringbool.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end