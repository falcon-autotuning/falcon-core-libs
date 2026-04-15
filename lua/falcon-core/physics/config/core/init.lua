-- physics/config/core/init.lua

return {
    Config = require("falcon-core.physics.config.core.config"),
    Group = require("falcon-core.physics.config.core.group"),
    Adjacency = require("falcon-core.physics.config.core.adjacency"),
    VoltageConstraints = require("falcon-core.physics.config.core.voltageconstraints"),
    GateRelations = require("falcon-core.physics.config.core.gaterelations"),
}
