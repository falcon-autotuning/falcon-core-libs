open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for ListWaveform *)
class type c_listwaveform_t = object
  method raw : unit ptr
end

class c_listwaveform : unit ptr -> c_listwaveform_t

module ListWaveform : sig
  type t = c_listwaveform

  val empty : t
  val copy : t -> t
  val fillValue : int -> Waveform.t -> t
  val make : Waveform.t -> int -> t
  val fromjson : string -> t
  val pushBack : t -> Waveform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Waveform.t
  val items : t -> Waveform.t -> int -> int
  val contains : t -> Waveform.t -> bool
  val index : t -> Waveform.t -> int
  val intersection : t -> t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
end