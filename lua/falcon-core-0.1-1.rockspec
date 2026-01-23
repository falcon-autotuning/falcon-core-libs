package = "falcon-core"
version = "0.1-1"
source = {
   url = "git+https://github.com/falcon-autotuning/falcon-core-libs.git",
   dir = "lua"
}
description = {
   summary = "Lua bindings for falcon-core",
   detailed = [[
      Lua bindings for falcon-core using LuaJIT FFI.
      Requires libfalcon_core_c_api.so to be installed on the system.
   ]],
   homepage = "https://github.com/falcon-autotuning/falcon-core-libs",
   license = "BSD-3-Clause",
   maintainer = "Daniel Schug"
}
dependencies = {
   "lua >= 5.1"
}
build = {
   type = "make",
   install_variables = {
      LUA_DIR = "$(LUADIR)",
   },
}
