-- communications/voltage_states/init.lua

return {
    DeviceVoltageState = require("falcon_core.communications.voltage_states.devicevoltagestate"),
    DeviceVoltageStates = require("falcon_core.communications.voltage_states.devicevoltagestates"),
    VoltageStatesResponse = require("falcon_core.communications.voltage_states.voltagestatesresponse"),
}
