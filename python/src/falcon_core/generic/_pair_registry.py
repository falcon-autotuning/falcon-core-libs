# Auto-generated template registry
# Do not edit manually

from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.autotuner_interfaces.names.gname import Gname
from falcon_core.physics.config.core.group import Group
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
from falcon_core.communications.messages.measurement_request import MeasurementRequest
from falcon_core.communications.messages.measurement_response import MeasurementResponse
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.math.quantity import Quantity

from falcon_core._capi.pair_channel_connections import PairChannelConnections as _CPairChannelConnections
from falcon_core._capi.pair_connection_connection import PairConnectionConnection as _CPairConnectionConnection
from falcon_core._capi.pair_connection_connections import PairConnectionConnections as _CPairConnectionConnections
from falcon_core._capi.pair_connection_double import PairConnectionDouble as _CPairConnectionDouble
from falcon_core._capi.pair_connection_float import PairConnectionFloat as _CPairConnectionFloat
from falcon_core._capi.pair_connection_pair_quantity_quantity import PairConnectionPairQuantityQuantity as _CPairConnectionPairQuantityQuantity
from falcon_core._capi.pair_connection_quantity import PairConnectionQuantity as _CPairConnectionQuantity
from falcon_core._capi.pair_double_double import PairDoubleDouble as _CPairDoubleDouble
from falcon_core._capi.pair_float_float import PairFloatFloat as _CPairFloatFloat
from falcon_core._capi.pair_gname_group import PairGnameGroup as _CPairGnameGroup
from falcon_core._capi.pair_instrument_port_port_transform import PairInstrumentPortPortTransform as _CPairInstrumentPortPortTransform
from falcon_core._capi.pair_int_float import PairIntFloat as _CPairIntFloat
from falcon_core._capi.pair_int_int import PairIntInt as _CPairIntInt
from falcon_core._capi.pair_interpretation_context_double import PairInterpretationContextDouble as _CPairInterpretationContextDouble
from falcon_core._capi.pair_interpretation_context_quantity import PairInterpretationContextQuantity as _CPairInterpretationContextQuantity
from falcon_core._capi.pair_interpretation_context_string import PairInterpretationContextString as _CPairInterpretationContextString
from falcon_core._capi.pair_measurement_response_measurement_request import PairMeasurementResponseMeasurementRequest as _CPairMeasurementResponseMeasurementRequest
from falcon_core._capi.pair_quantity_quantity import PairQuantityQuantity as _CPairQuantityQuantity
from falcon_core._capi.pair_size_t_size_t import PairSizeTSizeT as _CPairSizeTSizeT
from falcon_core._capi.pair_string_bool import PairStringBool as _CPairStringBool
from falcon_core._capi.pair_string_double import PairStringDouble as _CPairStringDouble
from falcon_core._capi.pair_string_string import PairStringString as _CPairStringString

PAIR_REGISTRY = {
    (Channel, Connections): _CPairChannelConnections,
    (Connection, Connection): _CPairConnectionConnection,
    (Connection, Connections): _CPairConnectionConnections,
    (Connection, float): _CPairConnectionDouble,
    (Connection, PairQuantityQuantity): _CPairConnectionPairQuantityQuantity,
    (Connection, Quantity): _CPairConnectionQuantity,
    (float, float): _CPairDoubleDouble,
    (Gname, Group): _CPairGnameGroup,
    (InstrumentPort, PortTransform): _CPairInstrumentPortPortTransform,
    (int, float): _CPairIntFloat,
    (int, int): _CPairIntInt,
    (InterpretationContext, float): _CPairInterpretationContextDouble,
    (InterpretationContext, Quantity): _CPairInterpretationContextQuantity,
    (InterpretationContext, str): _CPairInterpretationContextString,
    (MeasurementResponse, MeasurementRequest): _CPairMeasurementResponseMeasurementRequest,
    (Quantity, Quantity): _CPairQuantityQuantity,
    (str, bool): _CPairStringBool,
    (str, float): _CPairStringDouble,
    (str, str): _CPairStringString,
}