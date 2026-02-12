open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for String *)
class type c_string_t = object
  method raw : unit ptr
end

class c_string : unit ptr -> c_string_t

module String : sig
  type t = c_string

  val make : char -> int -> t
  val wrap : char -> t
end