# Auto-generated template registry
# Do not edit manually

from falcon_core.math.quantity import Quantity

from falcon_core._capi.interpretation_container_double import InterpretationContainerDouble as _CInterpretationContainerDouble
from falcon_core._capi.interpretation_container_quantity import InterpretationContainerQuantity as _CInterpretationContainerQuantity
from falcon_core._capi.interpretation_container_string import InterpretationContainerString as _CInterpretationContainerString

INTERPRETATIONCONTAINER_REGISTRY = {
    float: _CInterpretationContainerDouble,
    Quantity: _CInterpretationContainerQuantity,
    str: _CInterpretationContainerString,
}