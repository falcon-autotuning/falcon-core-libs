open Ctypes

(** Opaque handle for Time *)
class type c_time_t = object
  method raw : unit ptr
end

class c_time : unit ptr -> c_time_t

module Time : sig
  type t = c_time

end

module Time : sig
  type t = c_time

  val copy : t -> t
  val fromjson : string -> t
  val now : t
  val at : int64 -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val microSecondsSinceEpoch : t -> int64
  val time : t -> int64
  val toString : t -> string
end