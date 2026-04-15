-- context/init.lua
-- Context module aggregator

return {
    AcquisitionContext = require("falcon-core.context.acquisitioncontext"),
    MeasurementContext = require("falcon-core.context.measurementcontext"),
    InterpretationContext = require("falcon-core.context.interpretationcontext"),
}
