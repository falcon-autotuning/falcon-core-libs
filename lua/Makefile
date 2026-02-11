# Makefile for Lua falcon-core bindings

LUA_VERSION ?= 5.1
LUA_DIR ?= /usr/local/share/lua/$(LUA_VERSION)

.PHONY: all test install uninstall clean

all:
	@echo "Lua port is pure Lua (LuaJIT FFI), no build step required."

test:
	LUA_PATH="$$HOME/.luarocks/share/lua/5.4/?.lua;$$HOME/.luarocks/share/lua/5.4/?/init.lua;$$LUA_PATH" \
	LUA_CPATH="$$HOME/.luarocks/lib/lua/5.4/?.so;$$LUA_CPATH" \
	luajit run_tests.lua

install:
	mkdir -p $(DESTDIR)$(LUA_DIR)/falcon_core
	cp -r falcon_core/* $(DESTDIR)$(LUA_DIR)/falcon_core/

uninstall:
	rm -rf $(DESTDIR)$(LUA_DIR)/falcon_core

clean:
	@echo "Nothing to clean."
