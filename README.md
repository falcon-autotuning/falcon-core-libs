# Falcon Core Libs

Bindings of falcon-core in useful programming languages.
All of the languages are bound to the C-API from falcon-core.

The generated code falls under the same license as falcon-core itself, which is the BSD-3-Clause License.
We have included a copy of the license in the `LICENSE` file.

The most actively maintained language binding is Go, with Ocaml at a close second.

# Go bindings

The falcon-core language bindings for Go are located in the `go/falcon-core' directory.
When installing this package, make sure you have falcon-core installed on your system.
The go package is setup to to require a pkg-config installed somehere on your system. This pkg-config contains all of the locations of the header files and the shared library for falcon-core.
We recommend installing falcon-core at tmp/local/ such that the pkg-config file is located at`tmp/local/lib/pkgconfig/falcon-core.pc'.
We have a makefile setup for that can be accessed via 'make install'

# Python bindings

The falcon-core language bindings for Python are located in the `python/` directory.

### Quick Install (Pre-built Wheel)

To install without compilation (requires C-API libraries already installed in `/usr/local/lib`):

```bash
pip install https://github.com/falcon-autotuning/falcon-core-libs/releases/download/v0.0.2/falcon_core-0.0.0-cp314-cp314-linux_x86_64.whl
```

### Installation from Source

If a pre-built wheel is not available for your system:

```bash
# Install system dependencies
./install_dependencies.sh

# Install the package
pip install ./python
```

### Building Wheels

To generate a new binary wheel:

```bash
make wheel
```

This will use all available CPU cores for parallel Cythonization to speed up the process.

# OCaml bindings

The falcon-core language bindings for OCaml are located in the `ocaml/` directory.

### Installation via opam

```bash
cd ocaml/
opam install .
```

# Lua bindings

The falcon-core language bindings for Lua are located in the `lua/` directory.

### Installation via LuaRocks

```bash
cd lua/
luarocks make falcon-core-0.1-1.rockspec
```
