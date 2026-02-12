open Ctypes

(** Opaque handle for PairStringBool *)
class type c_pairstringbool_t = object
  method raw : unit ptr
end

class c_pairstringbool : unit ptr -> c_pairstringbool_t

module PairStringBool : sig
  type t = c_pairstringbool

end

module PairStringBool : sig
  type t = c_pairstringbool

  val make : string -> bool -> t
  val copy : t -> t
  val fromjson : string -> t
  val first : t -> string
  val second : t -> bool
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end