# Auto-generated template registry
# Do not edit manually

from falcon_core.math.arrays.control_array import ControlArray
from falcon_core.math.arrays.control_array1_d import ControlArray1D
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.discrete_spaces.discretizer import Discretizer
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.math.arrays.labelled_control_array import LabelledControlArray
from falcon_core.math.arrays.labelled_control_array1_d import LabelledControlArray1D
from falcon_core.math.arrays.labelled_measured_array import LabelledMeasuredArray
from falcon_core.math.arrays.labelled_measured_array1_d import LabelledMeasuredArray1D
from falcon_core._capi.map_string_bool import MapStringBool
from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext

from falcon_core._capi.axes_double import AxesDouble as _CAxesDouble
from falcon_core._capi.axes_int import AxesInt as _CAxesInt
from falcon_core._capi.axes_discretizer import AxesDiscretizer as _CAxesDiscretizer
from falcon_core._capi.axes_control_array import AxesControlArray as _CAxesControlArray
from falcon_core._capi.axes_control_array1_d import AxesControlArray1D as _CAxesControlArray1D
from falcon_core._capi.axes_coupled_labelled_domain import AxesCoupledLabelledDomain as _CAxesCoupledLabelledDomain
from falcon_core._capi.axes_instrument_port import AxesInstrumentPort as _CAxesInstrumentPort
from falcon_core._capi.axes_map_string_bool import AxesMapStringBool as _CAxesMapStringBool
from falcon_core._capi.axes_measurement_context import AxesMeasurementContext as _CAxesMeasurementContext
from falcon_core._capi.axes_labelled_control_array import AxesLabelledControlArray as _CAxesLabelledControlArray
from falcon_core._capi.axes_labelled_control_array1_d import AxesLabelledControlArray1D as _CAxesLabelledControlArray1D
from falcon_core._capi.axes_labelled_measured_array import AxesLabelledMeasuredArray as _CAxesLabelledMeasuredArray
from falcon_core._capi.axes_labelled_measured_array1_d import AxesLabelledMeasuredArray1D as _CAxesLabelledMeasuredArray1D

AXES_REGISTRY = {
    ControlArray: _CAxesControlArray,
    ControlArray1D: _CAxesControlArray1D,
    CoupledLabelledDomain: _CAxesCoupledLabelledDomain,
    Discretizer: _CAxesDiscretizer,
    InstrumentPort: _CAxesInstrumentPort,
    LabelledControlArray: _CAxesLabelledControlArray,
    LabelledControlArray1D: _CAxesLabelledControlArray1D,
    LabelledMeasuredArray: _CAxesLabelledMeasuredArray,
    LabelledMeasuredArray1D: _CAxesLabelledMeasuredArray1D,
    MapStringBool: _CAxesMapStringBool,
    MeasurementContext: _CAxesMeasurementContext,
    float: _CAxesDouble,
    int: _CAxesInt,
}