open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListPairChannelConnections *)
class type c_listpairchannelconnections_t = object
  method raw : unit ptr
end

class c_listpairchannelconnections : unit ptr -> c_listpairchannelconnections_t

module ListPairChannelConnections : sig
  type t = c_listpairchannelconnections

  val empty : t
  val copy : t -> t
  val fillValue : int -> Pairchannelconnections.t -> t
  val make : Pairchannelconnections.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Pairchannelconnections.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Pairchannelconnections.t
  val items : t -> Pairchannelconnections.t -> int -> int
  val contains : t -> Pairchannelconnections.t -> bool
  val index : t -> Pairchannelconnections.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end