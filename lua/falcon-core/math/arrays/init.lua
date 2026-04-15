-- math/arrays/init.lua
-- Math arrays module

return {
    MeasuredArray = require("falcon-core.math.arrays.measured_array"),
    MeasuredArray1D = require("falcon-core.math.arrays.measuredarray1d"),
    ControlArray = require("falcon-core.math.arrays.control_array"),
    ControlArray1D = require("falcon-core.math.arrays.controlarray1d"),
    LabelledMeasuredArray = require("falcon-core.math.arrays.labelled_measured_array"),
    LabelledMeasuredArray1D = require("falcon-core.math.arrays.labelledmeasuredarray1d"),
    LabelledControlArray = require("falcon-core.math.arrays.labelled_control_array"),
    LabelledControlArray1D = require("falcon-core.math.arrays.labelledcontrolarray1d"),
}
