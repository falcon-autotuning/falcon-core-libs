open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairChannelConnections *)
class type c_listpairchannelconnections_t = object
  method raw : unit ptr
end

class c_listpairchannelconnections : unit ptr -> c_listpairchannelconnections_t

module ListPairChannelConnections : sig
  type t = c_listpairchannelconnections

end

module ListPairChannelConnections : sig
  type t = c_listpairchannelconnections

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairChannelConnections.t -> t
  val make : PairChannelConnections.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairChannelConnections.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairChannelConnections.t
  val items : t -> PairChannelConnections.t -> int -> int
  val contains : t -> PairChannelConnections.t -> bool
  val index : t -> PairChannelConnections.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end