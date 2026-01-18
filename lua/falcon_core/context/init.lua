-- context/init.lua
-- Context module aggregator

return {
    AcquisitionContext = require("falcon_core.context.acquisitioncontext"),
    MeasurementContext = require("falcon_core.context.measurementcontext"),
    InterpretationContext = require("falcon_core.context.interpretationcontext"),
}
