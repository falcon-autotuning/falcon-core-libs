# Auto-generated template registry
# Do not edit manually

from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.autotuner_interfaces.names.gname import Gname
from falcon_core.physics.config.core.group import Group
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.autotuner_interfaces.interpretations.interpretation_context import InterpretationContext
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform
from falcon_core.math.quantity import Quantity

from falcon_core._capi.map_string_double import MapStringDouble as _CMapStringDouble
from falcon_core._capi.map_int_int import MapIntInt as _CMapIntInt
from falcon_core._capi.map_float_float import MapFloatFloat as _CMapFloatFloat
from falcon_core._capi.map_connection_float import MapConnectionFloat as _CMapConnectionFloat
from falcon_core._capi.map_connection_double import MapConnectionDouble as _CMapConnectionDouble
from falcon_core._capi.map_connection_quantity import MapConnectionQuantity as _CMapConnectionQuantity
from falcon_core._capi.map_string_bool import MapStringBool as _CMapStringBool
from falcon_core._capi.map_channel_connections import MapChannelConnections as _CMapChannelConnections
from falcon_core._capi.map_gname_group import MapGnameGroup as _CMapGnameGroup
from falcon_core._capi.map_instrument_port_port_transform import MapInstrumentPortPortTransform as _CMapInstrumentPortPortTransform
from falcon_core._capi.map_string_string import MapStringString as _CMapStringString
from falcon_core._capi.map_interpretation_context_double import MapInterpretationContextDouble as _CMapInterpretationContextDouble
from falcon_core._capi.map_interpretation_context_string import MapInterpretationContextString as _CMapInterpretationContextString
from falcon_core._capi.map_interpretation_context_quantity import MapInterpretationContextQuantity as _CMapInterpretationContextQuantity

MAP_REGISTRY = {
    (str, float): _CMapStringDouble,
    (int, int): _CMapIntInt,
    (float, float): _CMapFloatFloat,
    (Connection, float): _CMapConnectionFloat,
    (Connection, Quantity): _CMapConnectionQuantity,
    (str, bool): _CMapStringBool,
    (Channel, Connections): _CMapChannelConnections,
    (Gname, Group): _CMapGnameGroup,
    (InstrumentPort, PortTransform): _CMapInstrumentPortPortTransform,
    (str, str): _CMapStringString,
    (InterpretationContext, float): _CMapInterpretationContextDouble,
    (InterpretationContext, str): _CMapInterpretationContextString,
    (InterpretationContext, Quantity): _CMapInterpretationContextQuantity,
}