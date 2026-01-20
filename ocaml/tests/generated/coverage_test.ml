open Falcon_core

let () =
  print_endline "Running coverage tests... ";
  (* Testing HDF5Data *)
  (* TODO: call HDF5Data.from_json_string with dummy args *)
  (* Testing Time *)
  (* TODO: call Time.from_json_string with dummy args *)
  (* Testing String *)
  (* TODO: call String.make with dummy args *)
  (* Testing ListSizeT *)
  ignore (ListSizeT.new_empty ());
  (* Testing ListString *)
  ignore (ListString.new_empty ());
  (* Testing ListBool *)
  ignore (ListBool.new_empty ());
  (* Testing PairStringDouble *)
  (* TODO: call PairStringDouble.make with dummy args *)
  (* Testing PairStringBool *)
  (* TODO: call PairStringBool.make with dummy args *)
  (* Testing PairSizeTSizeT *)
  (* TODO: call PairSizeTSizeT.make with dummy args *)
  (* Testing ListPairSizeTSizeT *)
  ignore (ListPairSizeTSizeT.new_empty ());
  (* Testing ListPairStringDouble *)
  ignore (ListPairStringDouble.new_empty ());
  (* Testing ListListSizeT *)
  ignore (ListListSizeT.new_empty ());
  (* Testing FArrayDouble *)
  (* TODO: call FArrayDouble.new_empty with dummy args *)
  (* Testing ListFArrayDouble *)
  ignore (ListFArrayDouble.new_empty ());
  (* Testing FArrayInt *)
  (* TODO: call FArrayInt.new_empty with dummy args *)
  (* Testing ListInt *)
  ignore (ListInt.new_empty ());
  (* Testing ListFloat *)
  ignore (ListFloat.new_empty ());
  (* Testing ListDouble *)
  ignore (ListDouble.new_empty ());
  (* Testing PairIntInt *)
  (* TODO: call PairIntInt.make with dummy args *)
  (* Testing PairFloatFloat *)
  (* TODO: call PairFloatFloat.make with dummy args *)
  (* Testing PairDoubleDouble *)
  (* TODO: call PairDoubleDouble.make with dummy args *)
  (* Testing PairIntFloat *)
  (* TODO: call PairIntFloat.make with dummy args *)
  (* Testing PairQuantityQuantity *)
  (* TODO: call PairQuantityQuantity.make with dummy args *)
  (* Testing ListPairQuantityQuantity *)
  ignore (ListPairQuantityQuantity.new_empty ());
  (* Testing PairConnectionFloat *)
  (* TODO: call PairConnectionFloat.make with dummy args *)
  (* Testing PairConnectionDouble *)
  (* TODO: call PairConnectionDouble.make with dummy args *)
  (* Testing PairConnectionConnection *)
  (* TODO: call PairConnectionConnection.make with dummy args *)
  (* Testing ListConnection *)
  ignore (ListConnection.new_empty ());
  (* Testing ListChannel *)
  ignore (ListChannel.new_empty ());
  (* Testing ListQuantity *)
  ignore (ListQuantity.new_empty ());
  (* Testing ListDeviceVoltageState *)
  ignore (ListDeviceVoltageState.new_empty ());
  (* Testing ListLabelledDomain *)
  ignore (ListLabelledDomain.new_empty ());
  (* Testing ListInstrumentPort *)
  ignore (ListInstrumentPort.new_empty ());
  (* Testing ListConnections *)
  ignore (ListConnections.new_empty ());
  (* Testing ListImpedance *)
  ignore (ListImpedance.new_empty ());
  (* Testing PairConnectionConnections *)
  (* TODO: call PairConnectionConnections.make with dummy args *)
  (* Testing ListPairIntInt *)
  ignore (ListPairIntInt.new_empty ());
  (* Testing ListPairFloatFloat *)
  ignore (ListPairFloatFloat.new_empty ());
  (* Testing ListPairIntFloat *)
  ignore (ListPairIntFloat.new_empty ());
  (* Testing ListPairConnectionFloat *)
  ignore (ListPairConnectionFloat.new_empty ());
  (* Testing ListPairConnectionDouble *)
  ignore (ListPairConnectionDouble.new_empty ());
  (* Testing ListPairConnectionConnections *)
  ignore (ListPairConnectionConnections.new_empty ());
  (* Testing MapStringDouble *)
  ignore (MapStringDouble.new_empty ());
  (* Testing MapIntInt *)
  ignore (MapIntInt.new_empty ());
  (* Testing MapFloatFloat *)
  ignore (MapFloatFloat.new_empty ());
  (* Testing MapConnectionFloat *)
  ignore (MapConnectionFloat.new_empty ());
  (* Testing MapConnectionDouble *)
  ignore (MapConnectionDouble.new_empty ());
  (* Testing PairConnectionQuantity *)
  (* TODO: call PairConnectionQuantity.make with dummy args *)
  (* Testing ListPairConnectionQuantity *)
  ignore (ListPairConnectionQuantity.new_empty ());
  (* Testing MapConnectionQuantity *)
  ignore (MapConnectionQuantity.new_empty ());
  (* Testing PairConnectionPairQuantityQuantity *)
  (* TODO: call PairConnectionPairQuantityQuantity.make with dummy args *)
  (* Testing ListPairConnectionPairQuantityQuantity *)
  ignore (ListPairConnectionPairQuantityQuantity.new_empty ());
  (* Testing ListDiscretizer *)
  ignore (ListDiscretizer.new_empty ());
  (* Testing ListControlArray *)
  ignore (ListControlArray.new_empty ());
  (* Testing ListControlArray1D *)
  ignore (ListControlArray1D.new_empty ());
  (* Testing ListCoupledLabelledDomain *)
  ignore (ListCoupledLabelledDomain.new_empty ());
  (* Testing ListPairStringBool *)
  ignore (ListPairStringBool.new_empty ());
  (* Testing MapStringBool *)
  ignore (MapStringBool.new_empty ());
  (* Testing ListMapStringBool *)
  ignore (ListMapStringBool.new_empty ());
  (* Testing ListDotGateWithNeighbors *)
  ignore (ListDotGateWithNeighbors.new_empty ());
  (* Testing ListGroup *)
  ignore (ListGroup.new_empty ());
  (* Testing ListGname *)
  ignore (ListGname.new_empty ());
  (* Testing PairChannelConnections *)
  (* TODO: call PairChannelConnections.make with dummy args *)
  (* Testing ListPairChannelConnections *)
  ignore (ListPairChannelConnections.new_empty ());
  (* Testing MapChannelConnections *)
  ignore (MapChannelConnections.new_empty ());
  (* Testing PairGnameGroup *)
  (* TODO: call PairGnameGroup.make with dummy args *)
  (* Testing ListPairGnameGroup *)
  ignore (ListPairGnameGroup.new_empty ());
  (* Testing MapGnameGroup *)
  ignore (MapGnameGroup.new_empty ());
  (* Testing ListMeasurementContext *)
  ignore (ListMeasurementContext.new_empty ());
  (* Testing ListPortTransform *)
  ignore (ListPortTransform.new_empty ());
  (* Testing ListWaveform *)
  ignore (ListWaveform.new_empty ());
  (* Testing PairInstrumentPortPortTransform *)
  (* TODO: call PairInstrumentPortPortTransform.make with dummy args *)
  (* Testing ListPairInstrumentPortPortTransform *)
  ignore (ListPairInstrumentPortPortTransform.new_empty ());
  (* Testing MapInstrumentPortPortTransform *)
  ignore (MapInstrumentPortPortTransform.new_empty ());
  (* Testing ListLabelledControlArray *)
  ignore (ListLabelledControlArray.new_empty ());
  (* Testing ListAcquisitionContext *)
  ignore (ListAcquisitionContext.new_empty ());
  (* Testing ListLabelledControlArray1D *)
  ignore (ListLabelledControlArray1D.new_empty ());
  (* Testing ListLabelledMeasuredArray *)
  ignore (ListLabelledMeasuredArray.new_empty ());
  (* Testing ListLabelledMeasuredArray1D *)
  ignore (ListLabelledMeasuredArray1D.new_empty ());
  (* Testing PairStringString *)
  (* TODO: call PairStringString.make with dummy args *)
  (* Testing ListPairStringString *)
  ignore (ListPairStringString.new_empty ());
  (* Testing MapStringString *)
  ignore (MapStringString.new_empty ());
  (* Testing PairMeasurementResponseMeasurementRequest *)
  (* TODO: call PairMeasurementResponseMeasurementRequest.make with dummy args *)
  (* Testing ListInterpretationContext *)
  ignore (ListInterpretationContext.new_empty ());
  (* Testing PairInterpretationContextDouble *)
  (* TODO: call PairInterpretationContextDouble.make with dummy args *)
  (* Testing ListPairInterpretationContextDouble *)
  ignore (ListPairInterpretationContextDouble.new_empty ());
  (* Testing MapInterpretationContextDouble *)
  ignore (MapInterpretationContextDouble.new_empty ());
  (* Testing PairInterpretationContextString *)
  (* TODO: call PairInterpretationContextString.make with dummy args *)
  (* Testing MapInterpretationContextString *)
  ignore (MapInterpretationContextString.new_empty ());
  (* Testing ListPairInterpretationContextString *)
  ignore (ListPairInterpretationContextString.new_empty ());
  (* Testing PairInterpretationContextQuantity *)
  (* TODO: call PairInterpretationContextQuantity.make with dummy args *)
  (* Testing ListPairInterpretationContextQuantity *)
  ignore (ListPairInterpretationContextQuantity.new_empty ());
  (* Testing MapInterpretationContextQuantity *)
  ignore (MapInterpretationContextQuantity.new_empty ());
  (* Testing Waveform *)
  (* TODO: call Waveform.from_json_string with dummy args *)
  (* Testing AnalyticFunction *)
  (* TODO: call AnalyticFunction.from_json_string with dummy args *)
  (* Testing Point *)
  (* TODO: call Point.from_json_string with dummy args *)
  (* Testing Quantity *)
  (* TODO: call Quantity.from_json_string with dummy args *)
  (* Testing UnitSpace *)
  (* TODO: call UnitSpace.from_json_string with dummy args *)
  (* Testing Vector *)
  (* TODO: call Vector.from_json_string with dummy args *)
  (* Testing AxesDouble *)
  ignore (AxesDouble.new_empty ());
  (* Testing AxesInt *)
  ignore (AxesInt.new_empty ());
  (* Testing AxesDiscretizer *)
  ignore (AxesDiscretizer.new_empty ());
  (* Testing AxesControlArray *)
  ignore (AxesControlArray.new_empty ());
  (* Testing AxesControlArray1D *)
  ignore (AxesControlArray1D.new_empty ());
  (* Testing AxesCoupledLabelledDomain *)
  ignore (AxesCoupledLabelledDomain.new_empty ());
  (* Testing AxesInstrumentPort *)
  ignore (AxesInstrumentPort.new_empty ());
  (* Testing AxesMapStringBool *)
  ignore (AxesMapStringBool.new_empty ());
  (* Testing AxesMeasurementContext *)
  ignore (AxesMeasurementContext.new_empty ());
  (* Testing AxesLabelledControlArray *)
  ignore (AxesLabelledControlArray.new_empty ());
  (* Testing AxesLabelledControlArray1D *)
  ignore (AxesLabelledControlArray1D.new_empty ());
  (* Testing AxesLabelledMeasuredArray *)
  ignore (AxesLabelledMeasuredArray.new_empty ());
  (* Testing AxesLabelledMeasuredArray1D *)
  ignore (AxesLabelledMeasuredArray1D.new_empty ());
  (* Testing Loader *)
  (* TODO: call Loader.make with dummy args *)
  (* Testing Connection *)
  (* TODO: call Connection.from_json_string with dummy args *)
  (* Testing Connections *)
  (* TODO: call Connections.from_json_string with dummy args *)
  (* Testing GateRelations *)
  (* TODO: call GateRelations.from_json_string with dummy args *)
  (* Testing Impedance *)
  (* TODO: call Impedance.from_json_string with dummy args *)
  (* Testing Impedances *)
  (* TODO: call Impedances.from_json_string with dummy args *)
  (* Testing SymbolUnit *)
  (* TODO: call SymbolUnit.from_json_string with dummy args *)
  (* Testing Adjacency *)
  (* TODO: call Adjacency.from_json_string with dummy args *)
  (* Testing Config *)
  (* TODO: call Config.from_json_string with dummy args *)
  (* Testing Group *)
  (* TODO: call Group.from_json_string with dummy args *)
  (* Testing VoltageConstraints *)
  (* TODO: call VoltageConstraints.from_json_string with dummy args *)
  (* Testing DotGateWithNeighbors *)
  (* TODO: call DotGateWithNeighbors.from_json_string with dummy args *)
  (* Testing DotGatesWithNeighbors *)
  (* TODO: call DotGatesWithNeighbors.from_json_string with dummy args *)
  (* Testing GateGeometryArray1D *)
  (* TODO: call GateGeometryArray1D.from_json_string with dummy args *)
  (* Testing LeftReservoirWithImplantedOhmic *)
  (* TODO: call LeftReservoirWithImplantedOhmic.from_json_string with dummy args *)
  (* Testing RightReservoirWithImplantedOhmic *)
  (* TODO: call RightReservoirWithImplantedOhmic.from_json_string with dummy args *)
  (* Testing ControlArray1D *)
  (* TODO: call ControlArray1D.from_json_string with dummy args *)
  (* Testing ControlArray *)
  (* TODO: call ControlArray.from_json_string with dummy args *)
  (* Testing IncreasingAlignment *)
  (* TODO: call IncreasingAlignment.from_json_string with dummy args *)
  (* Testing LabelledControlArray1D *)
  (* TODO: call LabelledControlArray1D.from_json_string with dummy args *)
  (* Testing LabelledControlArray *)
  (* TODO: call LabelledControlArray.from_json_string with dummy args *)
  (* Testing LabelledMeasuredArray1D *)
  (* TODO: call LabelledMeasuredArray1D.from_json_string with dummy args *)
  (* Testing LabelledMeasuredArray *)
  (* TODO: call LabelledMeasuredArray.from_json_string with dummy args *)
  (* Testing MeasuredArray1D *)
  (* TODO: call MeasuredArray1D.from_json_string with dummy args *)
  (* Testing MeasuredArray *)
  (* TODO: call MeasuredArray.from_json_string with dummy args *)
  (* Testing LabelledArraysLabelledControlArray *)
  (* TODO: call LabelledArraysLabelledControlArray.make with dummy args *)
  (* Testing LabelledArraysLabelledControlArray1D *)
  (* TODO: call LabelledArraysLabelledControlArray1D.make with dummy args *)
  (* Testing LabelledArraysLabelledMeasuredArray *)
  (* TODO: call LabelledArraysLabelledMeasuredArray.make with dummy args *)
  (* Testing LabelledArraysLabelledMeasuredArray1D *)
  (* TODO: call LabelledArraysLabelledMeasuredArray1D.make with dummy args *)
  (* Testing DiscreteSpace *)
  (* TODO: call DiscreteSpace.from_json_string with dummy args *)
  (* Testing Discretizer *)
  (* TODO: call Discretizer.from_json_string with dummy args *)
  (* Testing CoupledLabelledDomain *)
  (* TODO: call CoupledLabelledDomain.from_json_string with dummy args *)
  (* Testing Domain *)
  (* TODO: call Domain.from_json_string with dummy args *)
  (* Testing LabelledDomain *)
  (* TODO: call LabelledDomain.from_json_string with dummy args *)
  (* Testing InstrumentPort *)
  (* TODO: call InstrumentPort.from_json_string with dummy args *)
  (* Testing Ports *)
  (* TODO: call Ports.from_json_string with dummy args *)
  (* Testing PortTransform *)
  (* TODO: call PortTransform.from_json_string with dummy args *)
  (* Testing PortTransforms *)
  (* TODO: call PortTransforms.from_json_string with dummy args *)
  (* Testing MeasurementRequest *)
  (* TODO: call MeasurementRequest.from_json_string with dummy args *)
  (* Testing MeasurementResponse *)
  (* TODO: call MeasurementResponse.from_json_string with dummy args *)
  (* Testing StandardRequest *)
  (* TODO: call StandardRequest.from_json_string with dummy args *)
  (* Testing StandardResponse *)
  (* TODO: call StandardResponse.from_json_string with dummy args *)
  (* Testing VoltageStatesResponse *)
  (* TODO: call VoltageStatesResponse.from_json_string with dummy args *)
  (* Testing DeviceVoltageState *)
  (* TODO: call DeviceVoltageState.make with dummy args *)
  (* Testing DeviceVoltageStates *)
  ignore (DeviceVoltageStates.new_empty ());
  (* Testing AcquisitionContext *)
  (* TODO: call AcquisitionContext.from_json_string with dummy args *)
  (* Testing MeasurementContext *)
  (* TODO: call MeasurementContext.from_json_string with dummy args *)
  (* Testing InterpretationContext *)
  (* TODO: call InterpretationContext.from_json_string with dummy args *)
  (* Testing InterpretationContainerDouble *)
  (* TODO: call InterpretationContainerDouble.make with dummy args *)
  (* Testing InterpretationContainerString *)
  (* TODO: call InterpretationContainerString.make with dummy args *)
  (* Testing InterpretationContainerQuantity *)
  (* TODO: call InterpretationContainerQuantity.make with dummy args *)
  (* Testing Channel *)
  (* TODO: call Channel.from_json_string with dummy args *)
  (* Testing Channels *)
  (* TODO: call Channels.from_json_string with dummy args *)
  (* Testing Gname *)
  (* TODO: call Gname.from_json_string with dummy args *)
  Printf.printf "\nCoverage Summary: %d / %d classes instantiated.\n" 80 166;
  print_endline "Done."