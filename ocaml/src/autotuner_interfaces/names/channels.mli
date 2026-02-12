open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Channels *)
class type c_channels_t = object
  method raw : unit ptr
end

class c_channels : unit ptr -> c_channels_t

module Channels : sig
  type t = c_channels

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : Listchannel.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val intersection : t -> t -> t
  val pushBack : t -> Channel.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Channel.t
  val items : t -> string
  val contains : t -> Channel.t -> bool
  val index : t -> Channel.t -> int
end