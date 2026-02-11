package = "falcon-core"
version = "0.1-1"
source = {
	url = "git+https://github.com/falcon-autotuning/falcon-core-libs.git",
	dir = "lua",
}
description = {
	summary = "Lua bindings for falcon-core",
	detailed = [[
      Lua bindings for falcon-core using LuaJIT FFI.
      Requires libfalcon_core_c_api.so to be installed on the system.
   ]],
	homepage = "https://github.com/falcon-autotuning/falcon-core-libs",
	license = "BSD-3-Clause",
	maintainer = "Daniel Schug",
}
dependencies = {
	"lua >= 5.1",
	"luacov",
}
build = {
	type = "make",
	install_variables = {
		LUA_DIR = "$(LUADIR)",
	},
	modules = {
		["falcon_core.autotuner_interfaces.contexts.autotuning_context"] = "autotuner_interfaces/contexts/autotuningcontext.lua",
		["falcon_core.autotuner_interfaces.contexts.interpretationcontext"] = "autotuner_interfaces/contexts/interpretationcontext.lua",
		["falcon_core.autotuner_interfaces.contexts.measurementcontext"] = "autotuner_interfaces/contexts/measurementcontext.lua",
		["falcon_core.autotuner_interfaces.interpretations.interpretationcontainerdouble"] = "autotuner_interfaces/interpretations/interpretationcontainerdouble.lua",
		["falcon_core.autotuner_interfaces.interpretations.interpretationcontainerquantity"] = "autotuner_interfaces/interpretations/interpretationcontainerquantity.lua",
		["falcon_core.autotuner_interfaces.interpretations.interpretationcontainerstring"] = "autotuner_interfaces/interpretations/interpretationcontainerstring.lua",
		["falcon_core.autotuner_interfaces.interpretations.interpretationcontext"] = "autotuner_interfaces/interpretations/interpretationcontext.lua",
		["falcon_core"] = "falcon_core.lua",
	},
}
