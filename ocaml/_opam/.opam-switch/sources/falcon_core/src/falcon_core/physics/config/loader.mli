open Ctypes

open Falcon_core.Physics.Config.Core

(** Opaque handle for Loader *)
class type c_loader_t = object
  method raw : unit ptr
end

class c_loader : unit ptr -> c_loader_t

module Loader : sig
  type t = c_loader

end

module Loader : sig
  type t = c_loader

  val make : string -> t
  val config : t -> Config.t
end