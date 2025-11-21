# Auto-generated template registry
# Do not edit manually

from falcon_core.autotuner_interfaces.contexts.acquisition_context import AcquisitionContext
from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.math.arrays.control_array import ControlArray
from falcon_core.math.arrays.control_array1_d import ControlArray1D
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.communications.voltage_states.device_voltage_state import DeviceVoltageState
from falcon_core.math.discrete_spaces.discretizer import Discretizer
from falcon_core.physics.config.geometries.dot_gate_with_neighbors import DotGateWithNeighbors
from falcon_core.autotuner_interfaces.names.gname import Gname
from falcon_core.physics.config.core.group import Group
from falcon_core.physics.device_structures.impedance import Impedance
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
from falcon_core.math.arrays.labelled_control_array import LabelledControlArray
from falcon_core.math.arrays.labelled_control_array1_d import LabelledControlArray1D
from falcon_core.math.domains.labelled_domain import LabelledDomain
from falcon_core.math.arrays.labelled_measured_array import LabelledMeasuredArray
from falcon_core.math.arrays.labelled_measured_array1_d import LabelledMeasuredArray1D
from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.math.quantity import Quantity
from falcon_core.instrument_interfaces.waveform import Waveform

from falcon_core._capi.list_acquisition_context import ListAcquisitionContext as _CListAcquisitionContext
from falcon_core._capi.list_bool import ListBool as _CListBool
from falcon_core._capi.list_channel import ListChannel as _CListChannel
from falcon_core._capi.list_connection import ListConnection as _CListConnection
from falcon_core._capi.list_connections import ListConnections as _CListConnections
from falcon_core._capi.list_control_array1_d import ListControlArray1D as _CListControlArray1D
from falcon_core._capi.list_control_array import ListControlArray as _CListControlArray
from falcon_core._capi.list_coupled_labelled_domain import ListCoupledLabelledDomain as _CListCoupledLabelledDomain
from falcon_core._capi.list_device_voltage_state import ListDeviceVoltageState as _CListDeviceVoltageState
from falcon_core._capi.list_discretizer import ListDiscretizer as _CListDiscretizer
from falcon_core._capi.list_dot_gate_with_neighbors import ListDotGateWithNeighbors as _CListDotGateWithNeighbors
from falcon_core._capi.list_double import ListDouble as _CListDouble
from falcon_core._capi.list_f_array_double import ListFArrayDouble as _CListFArrayDouble
from falcon_core._capi.list_float import ListFloat as _CListFloat
from falcon_core._capi.list_gname import ListGname as _CListGname
from falcon_core._capi.list_group import ListGroup as _CListGroup
from falcon_core._capi.list_impedance import ListImpedance as _CListImpedance
from falcon_core._capi.list_instrument_port import ListInstrumentPort as _CListInstrumentPort
from falcon_core._capi.list_int import ListInt as _CListInt
from falcon_core._capi.list_interpretation_context import ListInterpretationContext as _CListInterpretationContext
from falcon_core._capi.list_labelled_control_array1_d import ListLabelledControlArray1D as _CListLabelledControlArray1D
from falcon_core._capi.list_labelled_control_array import ListLabelledControlArray as _CListLabelledControlArray
from falcon_core._capi.list_labelled_domain import ListLabelledDomain as _CListLabelledDomain
from falcon_core._capi.list_labelled_measured_array1_d import ListLabelledMeasuredArray1D as _CListLabelledMeasuredArray1D
from falcon_core._capi.list_labelled_measured_array import ListLabelledMeasuredArray as _CListLabelledMeasuredArray
from falcon_core._capi.list_list_size_t import ListListSizeT as _CListListSizeT
from falcon_core._capi.list_map_string_bool import ListMapStringBool as _CListMapStringBool
from falcon_core._capi.list_measurement_context import ListMeasurementContext as _CListMeasurementContext
from falcon_core._capi.list_pair_channel_connections import ListPairChannelConnections as _CListPairChannelConnections
from falcon_core._capi.list_pair_connection_connections import ListPairConnectionConnections as _CListPairConnectionConnections
from falcon_core._capi.list_pair_connection_double import ListPairConnectionDouble as _CListPairConnectionDouble
from falcon_core._capi.list_pair_connection_float import ListPairConnectionFloat as _CListPairConnectionFloat
from falcon_core._capi.list_pair_connection_pair_quantity_quantity import ListPairConnectionPairQuantityQuantity as _CListPairConnectionPairQuantityQuantity
from falcon_core._capi.list_pair_connection_quantity import ListPairConnectionQuantity as _CListPairConnectionQuantity
from falcon_core._capi.list_pair_float_float import ListPairFloatFloat as _CListPairFloatFloat
from falcon_core._capi.list_pair_gname_group import ListPairGnameGroup as _CListPairGnameGroup
from falcon_core._capi.list_pair_instrument_port_port_transform import ListPairInstrumentPortPortTransform as _CListPairInstrumentPortPortTransform
from falcon_core._capi.list_pair_int_float import ListPairIntFloat as _CListPairIntFloat
from falcon_core._capi.list_pair_int_int import ListPairIntInt as _CListPairIntInt
from falcon_core._capi.list_pair_interpretation_context_double import ListPairInterpretationContextDouble as _CListPairInterpretationContextDouble
from falcon_core._capi.list_pair_interpretation_context_quantity import ListPairInterpretationContextQuantity as _CListPairInterpretationContextQuantity
from falcon_core._capi.list_pair_interpretation_context_string import ListPairInterpretationContextString as _CListPairInterpretationContextString
from falcon_core._capi.list_pair_quantity_quantity import ListPairQuantityQuantity as _CListPairQuantityQuantity
from falcon_core._capi.list_pair_size_t_size_t import ListPairSizeTSizeT as _CListPairSizeTSizeT
from falcon_core._capi.list_pair_string_bool import ListPairStringBool as _CListPairStringBool
from falcon_core._capi.list_pair_string_double import ListPairStringDouble as _CListPairStringDouble
from falcon_core._capi.list_pair_string_string import ListPairStringString as _CListPairStringString
from falcon_core._capi.list_port_transform import ListPortTransform as _CListPortTransform
from falcon_core._capi.list_quantity import ListQuantity as _CListQuantity
from falcon_core._capi.list_size_t import ListSizeT as _CListSizeT
from falcon_core._capi.list_string import ListString as _CListString
from falcon_core._capi.list_waveform import ListWaveform as _CListWaveform

LIST_REGISTRY = {
    AcquisitionContext: _CListAcquisitionContext,
    bool: _CListBool,
    Channel: _CListChannel,
    Connection: _CListConnection,
    Connections: _CListConnections,
    ControlArray1D: _CListControlArray1D,
    ControlArray: _CListControlArray,
    CoupledLabelledDomain: _CListCoupledLabelledDomain,
    DeviceVoltageState: _CListDeviceVoltageState,
    Discretizer: _CListDiscretizer,
    DotGateWithNeighbors: _CListDotGateWithNeighbors,
    float: _CListDouble,
    FArrayDouble: _CListFArrayDouble,
    Gname: _CListGname,
    Group: _CListGroup,
    Impedance: _CListImpedance,
    InstrumentPort: _CListInstrumentPort,
    int: _CListInt,
    InterpretationContext: _CListInterpretationContext,
    LabelledControlArray1D: _CListLabelledControlArray1D,
    LabelledControlArray: _CListLabelledControlArray,
    LabelledDomain: _CListLabelledDomain,
    LabelledMeasuredArray1D: _CListLabelledMeasuredArray1D,
    LabelledMeasuredArray: _CListLabelledMeasuredArray,
    ListSizeT: _CListListSizeT,
    MapStringBool: _CListMapStringBool,
    MeasurementContext: _CListMeasurementContext,
    PairChannelConnections: _CListPairChannelConnections,
    PairConnectionConnections: _CListPairConnectionConnections,
    PairConnectionDouble: _CListPairConnectionDouble,
    PairConnectionFloat: _CListPairConnectionFloat,
    PairConnectionPairQuantityQuantity: _CListPairConnectionPairQuantityQuantity,
    PairConnectionQuantity: _CListPairConnectionQuantity,
    PairFloatFloat: _CListPairFloatFloat,
    PairGnameGroup: _CListPairGnameGroup,
    PairInstrumentPortPortTransform: _CListPairInstrumentPortPortTransform,
    PairIntFloat: _CListPairIntFloat,
    PairIntInt: _CListPairIntInt,
    PairInterpretationContextDouble: _CListPairInterpretationContextDouble,
    PairInterpretationContextQuantity: _CListPairInterpretationContextQuantity,
    PairInterpretationContextString: _CListPairInterpretationContextString,
    PairQuantityQuantity: _CListPairQuantityQuantity,
    PairSizeTSizeT: _CListPairSizeTSizeT,
    PairStringBool: _CListPairStringBool,
    PairStringDouble: _CListPairStringDouble,
    PairStringString: _CListPairStringString,
    PortTransform: _CListPortTransform,
    Quantity: _CListQuantity,
    str: _CListString,
    Waveform: _CListWaveform,
}