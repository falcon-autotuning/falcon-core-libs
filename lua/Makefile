# Makefile for Lua falcon-core bindings

LUA_VERSION ?= 5.1
LUA_DIR ?= /usr/local/share/lua/$(LUA_VERSION)

.PHONY: all test install uninstall clean

all:
	@echo "Lua port is pure Lua (LuaJIT FFI), no build step required."

test:
	lua run_tests.lua

install:
	mkdir -p $(DESTDIR)$(LUA_DIR)/falcon_core
	cp -r falcon_core/* $(DESTDIR)$(LUA_DIR)/falcon_core/

uninstall:
	rm -rf $(DESTDIR)$(LUA_DIR)/falcon_core

clean:
	@echo "Nothing to clean."
