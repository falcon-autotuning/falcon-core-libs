-- Test that ALL modules load successfully
local function test_all_modules()
    print("\n=== Testing Complete Module Loading ===\n")
    
    local fc = require("falcon_core")
    
    -- Test generic
    assert(fc.generic.FArray, "FArray missing")
    assert(fc.generic.List, "List missing")
    assert(fc.generic.Map, "Map missing")
    assert(fc.generic.Pair, "Pair missing")
    assert(fc.generic.Axes, "Axes missing")
    print("✓ Generic types loaded")
    
    -- Test math
    assert(fc.math.Quantity, "Quantity missing")
    assert(fc.math.arrays, "Math.arrays missing")
    assert(fc.math.domains, "Math.domains missing")
    assert(fc.math.discrete_spaces, "Math.discrete_spaces missing")
    print("✓ Math types loaded")
    
    -- Test autotuner_interfaces
    assert(fc.autotuner_interfaces.contexts, "Contexts missing")
    assert(fc.autotuner_interfaces.interpretations, "Interpretations missing")
    assert(fc.autotuner_interfaces.names, "Names missing")
    print("✓ Autotuner interfaces loaded")
    
    -- Test instrument_interfaces
    assert(fc.instrument_interfaces.Port, "Port missing")
    assert(fc.instrument_interfaces.port_transforms, "Port transforms missing")
    assert(fc.instrument_interfaces.names, "Instrument names missing")
    print("✓ Instrument interfaces loaded")
    
    -- Test communications
    assert(fc.communications.messages, "Messages missing")
    assert(fc.communications.voltage_states, "Voltage states missing")
    print("✓ Communications loaded")
    
    -- Test physics
    assert(fc.physics.config, "Physics config missing")
    assert(fc.physics.config.core, "Physics core missing")
    assert(fc.physics.config.geometries, "Physics geometries missing")
    print("✓ Physics loaded")
    
    -- Test io
    assert(fc.io.Loader, "Loader missing")
    print("✓ I/O loaded")
    
    print("\n✅ ALL MODULES LOADED SUCCESSFULLY\n")
    return true
end

local ok, err = pcall(test_all_modules)
if not ok then
    print("❌ ERROR: " .. tostring(err))
    os.exit(1)
end
