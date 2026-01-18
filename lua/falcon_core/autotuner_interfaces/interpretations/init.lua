-- autotuner_interfaces/interpretations/init.lua

return {
    InterpretationContext = require("falcon_core.autotuner_interfaces.interpretations.interpretationcontext"),
    InterpretationContainerDouble = require("falcon_core.autotuner_interfaces.interpretations.interpretationcontainerdouble"),
    InterpretationContainerQuantity = require("falcon_core.autotuner_interfaces.interpretations.interpretationcontainerquantity"),
    InterpretationContainerString = require("falcon_core.autotuner_interfaces.interpretations.interpretationcontainerstring"),
}
