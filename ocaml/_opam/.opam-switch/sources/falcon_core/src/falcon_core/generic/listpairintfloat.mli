open Ctypes

open Falcon_core.Generic

(** Opaque handle for ListPairIntFloat *)
class type c_listpairintfloat_t = object
  method raw : unit ptr
end

class c_listpairintfloat : unit ptr -> c_listpairintfloat_t

module ListPairIntFloat : sig
  type t = c_listpairintfloat

end

module ListPairIntFloat : sig
  type t = c_listpairintfloat

  val empty : t
  val copy : t -> t
  val fillValue : int -> PairIntFloat.t -> t
  val make : PairIntFloat.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> PairIntFloat.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PairIntFloat.t
  val items : t -> PairIntFloat.t -> int -> int
  val contains : t -> PairIntFloat.t -> bool
  val index : t -> PairIntFloat.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end