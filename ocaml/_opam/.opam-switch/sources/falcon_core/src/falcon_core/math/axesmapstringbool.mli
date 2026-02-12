open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic

(** Opaque handle for AxesMapStringBool *)
class type c_axesmapstringbool_t = object
  method raw : unit ptr
end

class c_axesmapstringbool : unit ptr -> c_axesmapstringbool_t

module AxesMapStringBool : sig
  type t = c_axesmapstringbool

end

module AxesMapStringBool : sig
  type t = c_axesmapstringbool

  val empty : t
  val copy : t -> t
  val make : ListMapStringBool.t -> t
  val fromjson : string -> t
  val pushBack : t -> MapStringBool.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> MapStringBool.t
  val items : t -> MapStringBool.t -> int -> int
  val contains : t -> MapStringBool.t -> bool
  val index : t -> MapStringBool.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end