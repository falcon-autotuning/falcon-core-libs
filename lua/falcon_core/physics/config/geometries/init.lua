-- physics/config/geometries/init.lua

return {
    GateGeometryArray1D = require("falcon_core.physics.config.geometries.gategeometryarray1d"),
    DotGateWithNeighbors = require("falcon_core.physics.config.geometries.dotgatewithneighbors"),
    DotGatesWithNeighbors = require("falcon_core.physics.config.geometries.dotgateswithneighbors"),
}
