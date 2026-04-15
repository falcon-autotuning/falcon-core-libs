-- communications/messages/init.lua

return {
    MeasurementRequest = require("falcon-core.communications.messages.measurementrequest"),
    MeasurementResponse = require("falcon-core.communications.messages.measurementresponse"),
    StandardRequest = require("falcon-core.communications.messages.standardrequest"),
    StandardResponse = require("falcon-core.communications.messages.standardresponse"),
}
