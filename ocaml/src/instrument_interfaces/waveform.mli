open Ctypes

(* No opens needed - using qualified names *)

(** Opaque handle for Waveform *)
class type c_waveform_t = object
  method raw : unit ptr
end

class c_waveform : unit ptr -> c_waveform_t

module Waveform : sig
  type t = c_waveform

  val copy : t -> t
  val fromjson : string -> t
  val make : Discretespace.t -> Listporttransform.t -> t
  val cartesianWaveform : Axesint.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> Listporttransform.t -> Domain.t -> t
  val cartesianIdentityWaveform : Axesint.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> Domain.t -> t
  val cartesianWaveform2d : Axesint.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> Listporttransform.t -> Domain.t -> t
  val cartesianIdentityWaveform2d : Axesint.t -> Axescoupledlabelleddomain.t -> Axesmapstringbool.t -> Domain.t -> t
  val cartesianWaveform1d : int -> Coupledlabelleddomain.t -> Mapstringbool.t -> Listporttransform.t -> Domain.t -> t
  val cartesianIdentityWaveform1d : int -> Coupledlabelleddomain.t -> Mapstringbool.t -> Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> Discretespace.t
  val transforms : t -> Listporttransform.t
  val pushBack : t -> Porttransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Porttransform.t
  val items : t -> Listporttransform.t
  val contains : t -> Porttransform.t -> bool
  val index : t -> Porttransform.t -> int
  val intersection : t -> t -> t
end