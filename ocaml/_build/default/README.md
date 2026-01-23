# FAlCon Core OCaml Bindings

OCaml bindings for `falcon-core` generated using `ctypes`.

## Prerequisites

- OCaml (>= 4.14.0)
- Dune (>= 3.0)
- `ctypes` and `ctypes-foreign`
- `libfalcon_core_c_api.so` installed in your library path (e.g., `/usr/local/lib`).

## Installation

### From Source

```bash
make install
```

This will build the library and install it into your current opam switch.

## Development

### Building

```bash
make build
```

### Running Tests

```bash
make test
```

### Cleaning

```bash
make clean
```

## Usage

In your project's `dune` file:

```lisp
(executable
 (name my_prog)
 (libraries falcon_core))
```
