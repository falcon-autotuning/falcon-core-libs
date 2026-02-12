open Ctypes

open Falcon_core.Generic
open Falcon_core.Generic
open Falcon_core.Instrument_interfaces.Port_transforms
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math
open Falcon_core.Math.Discrete_spaces
open Falcon_core.Math.Domains
open Falcon_core.Math.Domains

(** Opaque handle for Waveform *)
class type c_waveform_t = object
  method raw : unit ptr
end

class c_waveform : unit ptr -> c_waveform_t

module Waveform : sig
  type t = c_waveform

end

module Waveform : sig
  type t = c_waveform

  val copy : t -> t
  val fromjson : string -> t
  val make : DiscreteSpace.t -> ListPortTransform.t -> t
  val cartesianWaveform : AxesInt.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> ListPortTransform.t -> Domain.t -> t
  val cartesianIdentityWaveform : AxesInt.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> Domain.t -> t
  val cartesianWaveform2d : AxesInt.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> ListPortTransform.t -> Domain.t -> t
  val cartesianIdentityWaveform2d : AxesInt.t -> AxesCoupledLabelledDomain.t -> AxesMapStringBool.t -> Domain.t -> t
  val cartesianWaveform1d : int -> CoupledLabelledDomain.t -> MapStringBool.t -> ListPortTransform.t -> Domain.t -> t
  val cartesianIdentityWaveform1d : int -> CoupledLabelledDomain.t -> MapStringBool.t -> Domain.t -> t
  val equal : t -> t -> bool
  val notEqual : t -> t -> bool
  val toJsonString : t -> string
  val space : t -> DiscreteSpace.t
  val transforms : t -> ListPortTransform.t
  val pushBack : t -> PortTransform.t -> unit
  val size : t -> int
  val empty : t -> bool
  val eraseAt : t -> int -> unit
  val clear : t -> unit
  val at : t -> int -> PortTransform.t
  val items : t -> ListPortTransform.t
  val contains : t -> PortTransform.t -> bool
  val index : t -> PortTransform.t -> int
  val intersection : t -> t -> t
end