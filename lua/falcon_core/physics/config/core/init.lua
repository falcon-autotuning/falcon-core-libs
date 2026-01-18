-- physics/config/core/init.lua

return {
    Config = require("falcon_core.physics.config.core.config"),
    Group = require("falcon_core.physics.config.core.group"),
    Adjacency = require("falcon_core.physics.config.core.adjacency"),
    VoltageConstraints = require("falcon_core.physics.config.core.voltageconstraints"),
    GateRelations = require("falcon_core.physics.config.core.gaterelations"),
}
