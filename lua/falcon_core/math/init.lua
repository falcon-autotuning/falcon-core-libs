-- math/init.lua
-- Math module with submodules

return {
    -- Root level math types
    Quantity = require("falcon_core.math.quantity"),
    Vector = require("falcon_core.math.vector"),
    Point = require("falcon_core.math.point"),
    SymbolUnit = require("falcon_core.math.symbolunit"),
    UnitSpace = require("falcon_core.math.unitspace"),
    AnalyticFunction = require("falcon_core.math.analyticfunction"),
    IncreasingAlignment = require("falcon_core.math.increasingalignment"),
    Sign = require("falcon_core.math.sign"),
    
    -- Submodules
    arrays = require("falcon_core.math.arrays"),
    discrete_spaces = require("falcon_core.math.discrete_spaces"),
    domains = require("falcon_core.math.domains"),
}
