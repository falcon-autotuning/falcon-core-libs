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
  val make : Discretespace.DiscreteSpace.t -> Listporttransform.ListPortTransform.t -> t
  val cartesianWaveform : Axesint.AxesInt.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> Listporttransform.ListPortTransform.t -> Domain.Domain.t -> t
  val cartesianIdentityWaveform : Axesint.AxesInt.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> Domain.Domain.t -> t
  val cartesianWaveform2d : Axesint.AxesInt.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> Listporttransform.ListPortTransform.t -> Domain.Domain.t -> t
  val cartesianIdentityWaveform2d : Axesint.AxesInt.t -> Axescoupledlabelleddomain.AxesCoupledLabelledDomain.t -> Axesmapstringbool.AxesMapStringBool.t -> Domain.Domain.t -> t
  val cartesianWaveform1d : int -> Coupledlabelleddomain.CoupledLabelledDomain.t -> Mapstringbool.MapStringBool.t -> Listporttransform.ListPortTransform.t -> Domain.Domain.t -> t
  val cartesianIdentityWaveform1d : int -> Coupledlabelleddomain.CoupledLabelledDomain.t -> Mapstringbool.MapStringBool.t -> Domain.Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> Discretespace.DiscreteSpace.t
  val transforms : t -> Listporttransform.ListPortTransform.t
  val pushBack : t -> Porttransform.PortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> Porttransform.PortTransform.t
  val items : t -> Listporttransform.ListPortTransform.t
  val contains : t -> Porttransform.PortTransform.t -> bool
  val index : t -> Porttransform.PortTransform.t -> int
  val intersection : t -> t -> t
end