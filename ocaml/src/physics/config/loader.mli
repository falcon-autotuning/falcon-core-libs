open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Loader *)
class type c_loader_t = object
  method raw : unit ptr
end

class c_loader : unit ptr -> c_loader_t

module Loader : sig
  type t = c_loader

  val make : string -> t
  val config : t -> Config.Config.t
end