-- communications/messages/init.lua

return {
    MeasurementRequest = require("falcon_core.communications.messages.measurementrequest"),
    MeasurementResponse = require("falcon_core.communications.messages.measurementresponse"),
    StandardRequest = require("falcon_core.communications.messages.standardrequest"),
    StandardResponse = require("falcon_core.communications.messages.standardresponse"),
}
