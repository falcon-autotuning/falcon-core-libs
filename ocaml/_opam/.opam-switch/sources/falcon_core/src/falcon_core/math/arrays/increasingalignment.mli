open Ctypes

(** Opaque handle for IncreasingAlignment *)
class type c_increasingalignment_t = object
  method raw : unit ptr
end

class c_increasingalignment : unit ptr -> c_increasingalignment_t

module IncreasingAlignment : sig
  type t = c_increasingalignment

end

module IncreasingAlignment : sig
  type t = c_increasingalignment

  val copy : t -> t
  val fromjson : string -> t
  val empty : t
  val make : bool -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val alignment : t -> int
end