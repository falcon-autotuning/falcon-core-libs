open Ctypes

(** Opaque handle for StandardRequest *)
class type c_standardrequest_t = object
  method raw : unit ptr
end

class c_standardrequest : unit ptr -> c_standardrequest_t

module StandardRequest : sig
  type t = c_standardrequest

end

module StandardRequest : sig
  type t = c_standardrequest

  val copy : t -> t
  val fromjson : string -> t
  val make : string -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val message : t -> string
end