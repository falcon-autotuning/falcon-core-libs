-- autotuner_interfaces/interpretations/init.lua

return {
    InterpretationContext = require("falcon-core.autotuner_interfaces.interpretations.interpretationcontext"),
    InterpretationContainerDouble = require("falcon-core.autotuner_interfaces.interpretations.interpretationcontainerdouble"),
    InterpretationContainerQuantity = require("falcon-core.autotuner_interfaces.interpretations.interpretationcontainerquantity"),
    InterpretationContainerString = require("falcon-core.autotuner_interfaces.interpretations.interpretationcontainerstring"),
}
