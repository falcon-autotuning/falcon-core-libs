# falcon-core Lua Port

Complete Lua language bindings for falcon-core, providing native access to all C++ types and functions.

## Overview

This is a comprehensive Lua port of the `falcon-core` C++ library, built using LuaJIT FFI. It provides:
- **174 wrapped types**: All falcon-core C-API types with Lua-friendly interfaces
- **Generic type abstraction**: FArray, List, Map with runtime type dispatch
- **Automatic memory management**: GC-based cleanup via `__gc` metamethods
- **Native serialization**: Direct access to C++ cereal JSON encoding
- **Comprehensive tests**: Full unit and integration test coverage

## Installation

### Dependencies
- LuaJIT 2.0+
- falcon-core C-API library (`libfalcon_core_c_api.so`)

### Via LuaRocks

```bash
luarocks install falcon-core
```

### From Source

```bash
cd lua/
luarocks make falcon-core-0.1-1.rockspec
```

### Using Makefile (Optional)

```bash
make install
```

## Quick Start

```lua
local falcon = require("falcon_core")

-- Create a Quantity with units
local q = falcon.math.Quantity.new(10.5, "mV")
print(q:to_json())  -- Uses C++ cereal serialization

-- Generic FArray (dispatches to FArrayDouble)
local arr = falcon.generic.FArray.new("double", {1.0, 2.0, 3.0})
arr:push(4.0)
local json = arr:to_json()

-- Automatic memory management (no manual cleanup needed)
```

## Structure

```
lua/
├── falcon_core/        # Library modules
│   ├── ffi/           # Low-level FFI bindings
│   ├── generic/       # FArray, List, Map dispatchers
│   ├── math/          # Quantity, Vector, Point
│   ├── instrument/    # Ports, Connections
│   ├── physics/       # Config, Groups
│   └── arrays/        # MeasuredArray, ControlArray
├── tests/             # Test suite
└── scripts/           # Build/generation scripts
```

## Development

### Running Tests

```bash
cd lua/
luajit run_tests.lua
```

### Coverage

```bash
cd lua/
luajit run_lua_coverage.lua
```

### Regenerating Bindings
```bash
cd lua/scripts/
python3 generate_bindings.py
```

## Documentation

- [API Reference](docs/api.md)
- [Type Mapping Guide](docs/types.md)
- [Migration from Python](docs/python-comparison.md)

## License

See LICENSE.txt in falcon-core root.
