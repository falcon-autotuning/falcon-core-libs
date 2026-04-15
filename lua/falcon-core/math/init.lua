-- math/init.lua
-- Math module with submodules

return {
    -- Root level math types
    Quantity = require("falcon-core.math.quantity"),
    Vector = require("falcon-core.math.vector"),
    Point = require("falcon-core.math.point"),
    SymbolUnit = require("falcon-core.math.symbolunit"),
    UnitSpace = require("falcon-core.math.unitspace"),
    AnalyticFunction = require("falcon-core.math.analyticfunction"),
    IncreasingAlignment = require("falcon-core.math.increasingalignment"),
    Sign = require("falcon-core.math.sign"),
    
    -- Submodules
    arrays = require("falcon-core.math.arrays"),
    discrete_spaces = require("falcon-core.math.discrete_spaces"),
    domains = require("falcon-core.math.domains"),
}
