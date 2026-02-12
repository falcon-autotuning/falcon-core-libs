(* Auto-generated main module *)
open Ctypes
open Capi_bindings

(* Error handling module - similar to Go's cmemoryallocation/errorhandling *)
open Ctypes
open Foreign

module ErrorHandling = struct
exception CApiError of string

(* C-API error handling functions *)
let lib = Dl.dlopen ~filename:"libfalcon_core_c_api.so" ~flags:[Dl.RTLD_NOW]

(* External C functions for error handling *)
let c_get_last_error_code = 
    foreign ~from:lib "get_last_error_code" (void @-> returning int)

let c_get_last_error_msg = 
    foreign ~from:lib "get_last_error_msg" (void @-> returning string)

let c_set_last_error = 
    foreign ~from:lib "set_last_error" (int @-> string @-> returning void)

(* Check for C-API errors after a call *)
let check_error () : string option =
    let code = c_get_last_error_code () in
    if code = 0 then
    None
    else
    let msg = c_get_last_error_msg () in
    Some msg

let raise_if_error () =
    match check_error () with
    | Some err -> 
        (* Reset error before raising *)
        c_set_last_error 0 "";
        raise (CApiError err)
    | None -> ()

(* Reset error state *)
let reset_error () =
    c_set_last_error 0 ""

(* Read wrapper - validates handle and checks errors *)
let read (handle : 'a) (f : unit -> 'b) : 'b =
    (* In OCaml, we can't easily check if object is null without reflection *)
    (* The C-API will return errors if handle is invalid *)
    let result = f () in
    raise_if_error ();
    result

(* Write wrapper - checks errors after write operation *)
let write (handle : 'a) (f : unit -> unit) : unit =
    f ();
    raise_if_error ()

(* MultiRead - validates multiple handles *)
let multi_read (handles : 'a list) (f : unit -> 'b) : 'b =
    let result = f () in
    raise_if_error ();
    result

(* ReadWrite - combination of read and write *)
let read_write (write_handle : 'a) (read_handles : 'b list) (f : unit -> unit) : unit =
    f ();
    raise_if_error ()
    
(* Helper to wrap C calls that might fail *)
let with_error_check (f : unit -> 'a) : 'a =
    let result = f () in
    raise_if_error ();
    result
end


module Falcon_core = struct

  module Falcon_core = struct
  module Autotuner_interfaces = struct
  module Contexts = struct
    include AcquisitionContext
    include MeasurementContext
  end
  end
  end

  module Falcon_core = struct
  module Autotuner_interfaces = struct
  module Interpretations = struct
    include InterpretationContainerDouble
    include InterpretationContainerQuantity
    include InterpretationContainerString
    include InterpretationContext
  end
  end
  end

  module Falcon_core = struct
  module Autotuner_interfaces = struct
  module Names = struct
    include Channel
    include Channels
    include Gname
  end
  end
  end

  module Falcon_core = struct
  module Communications = struct
    include HDF5Data
    include Time
  end
  end

  module Falcon_core = struct
  module Communications = struct
  module Messages = struct
    include MeasurementRequest
    include MeasurementResponse
    include StandardRequest
    include StandardResponse
    include VoltageStatesResponse
  end
  end
  end

  module Falcon_core = struct
  module Communications = struct
  module Voltage_states = struct
    include DeviceVoltageState
    include DeviceVoltageStates
  end
  end
  end

  module Falcon_core = struct
  module Generic = struct
    include FArrayDouble
    include FArrayInt
    include ListAcquisitionContext
    include ListBool
    include ListChannel
    include ListConnection
    include ListConnections
    include ListControlArray1D
    include ListControlArray
    include ListCoupledLabelledDomain
    include ListDeviceVoltageState
    include ListDiscretizer
    include ListDotGateWithNeighbors
    include ListDouble
    include ListFArrayDouble
    include ListFloat
    include ListGname
    include ListGroup
    include ListImpedance
    include ListInstrumentPort
    include ListInt
    include ListInterpretationContext
    include ListLabelledControlArray1D
    include ListLabelledControlArray
    include ListLabelledDomain
    include ListLabelledMeasuredArray1D
    include ListLabelledMeasuredArray
    include ListListSizeT
    include ListMapStringBool
    include ListMeasurementContext
    include ListPairChannelConnections
    include ListPairConnectionConnections
    include ListPairConnectionDouble
    include ListPairConnectionFloat
    include ListPairConnectionPairQuantityQuantity
    include ListPairConnectionQuantity
    include ListPairFloatFloat
    include ListPairGnameGroup
    include ListPairInstrumentPortPortTransform
    include ListPairIntFloat
    include ListPairIntInt
    include ListPairInterpretationContextDouble
    include ListPairInterpretationContextQuantity
    include ListPairInterpretationContextString
    include ListPairQuantityQuantity
    include ListPairSizeTSizeT
    include ListPairStringBool
    include ListPairStringDouble
    include ListPairStringString
    include ListPortTransform
    include ListQuantity
    include ListSizeT
    include ListString
    include ListWaveform
    include MapChannelConnections
    include MapConnectionDouble
    include MapConnectionFloat
    include MapConnectionQuantity
    include MapFloatFloat
    include MapGnameGroup
    include MapInstrumentPortPortTransform
    include MapIntInt
    include MapInterpretationContextDouble
    include MapInterpretationContextQuantity
    include MapInterpretationContextString
    include MapStringBool
    include MapStringDouble
    include MapStringString
    include PairChannelConnections
    include PairConnectionConnection
    include PairConnectionConnections
    include PairConnectionDouble
    include PairConnectionFloat
    include PairConnectionPairQuantityQuantity
    include PairConnectionQuantity
    include PairDoubleDouble
    include PairFloatFloat
    include PairGnameGroup
    include PairInstrumentPortPortTransform
    include PairIntFloat
    include PairIntInt
    include PairInterpretationContextDouble
    include PairInterpretationContextQuantity
    include PairInterpretationContextString
    include PairMeasurementResponseMeasurementRequest
    include PairQuantityQuantity
    include PairSizeTSizeT
    include PairStringBool
    include PairStringDouble
    include PairStringString
    include String
  end
  end

  module Falcon_core = struct
  module Instrument_interfaces = struct
    include Waveform
  end
  end

  module Falcon_core = struct
  module Instrument_interfaces = struct
  module Names = struct
    include InstrumentPort
    include Ports
  end
  end
  end

  module Falcon_core = struct
  module Instrument_interfaces = struct
  module Port_transforms = struct
    include PortTransform
    include PortTransforms
  end
  end
  end

  module Falcon_core = struct
  module Math = struct
    include AnalyticFunction
    include AxesControlArray1D
    include AxesControlArray
    include AxesCoupledLabelledDomain
    include AxesDiscretizer
    include AxesDouble
    include AxesInstrumentPort
    include AxesInt
    include AxesLabelledControlArray1D
    include AxesLabelledControlArray
    include AxesLabelledMeasuredArray1D
    include AxesLabelledMeasuredArray
    include AxesMapStringBool
    include AxesMeasurementContext
    include Point
    include Quantity
    include UnitSpace
    include Vector
  end
  end

  module Falcon_core = struct
  module Math = struct
  module Arrays = struct
    include ControlArray1D
    include ControlArray
    include IncreasingAlignment
    include LabelledArraysLabelledControlArray1D
    include LabelledArraysLabelledControlArray
    include LabelledArraysLabelledMeasuredArray1D
    include LabelledArraysLabelledMeasuredArray
    include LabelledControlArray1D
    include LabelledControlArray
    include LabelledMeasuredArray1D
    include LabelledMeasuredArray
    include MeasuredArray1D
    include MeasuredArray
  end
  end
  end

  module Falcon_core = struct
  module Math = struct
  module Discrete_spaces = struct
    include DiscreteSpace
    include Discretizer
  end
  end
  end

  module Falcon_core = struct
  module Math = struct
  module Domains = struct
    include CoupledLabelledDomain
    include Domain
    include LabelledDomain
  end
  end
  end

  module Falcon_core = struct
  module Physics = struct
  module Config = struct
    include Loader
  end
  end
  end

  module Falcon_core = struct
  module Physics = struct
  module Config = struct
  module Core = struct
    include Adjacency
    include Config
    include Group
    include VoltageConstraints
  end
  end
  end
  end

  module Falcon_core = struct
  module Physics = struct
  module Config = struct
  module Geometries = struct
    include DotGateWithNeighbors
    include DotGatesWithNeighbors
    include GateGeometryArray1D
    include LeftReservoirWithImplantedOhmic
    include RightReservoirWithImplantedOhmic
  end
  end
  end
  end

  module Falcon_core = struct
  module Physics = struct
  module Device_structures = struct
    include Connection
    include Connections
    include GateRelations
    include Impedance
    include Impedances
  end
  end
  end

  module Falcon_core = struct
  module Physics = struct
  module Units = struct
    include SymbolUnit
  end
  end
  end

end