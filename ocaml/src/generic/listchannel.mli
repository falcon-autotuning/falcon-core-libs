open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListChannel *)
class type c_listchannel_t = object
  method raw : unit ptr
end

class c_listchannel : unit ptr -> c_listchannel_t

module ListChannel : sig
  type t = c_listchannel

  val empty : t
  val copy : t -> t
  val fillValue : int -> Channel.Channel.t -> t
  val make : Channel.Channel.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Channel.Channel.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Channel.Channel.t
  val items : t -> Channel.Channel.t -> int -> int
  val contains : t -> Channel.Channel.t -> bool
  val index : t -> Channel.Channel.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end