# FAlCon Core OCaml Bindings

OCaml bindings for `falcon-core` generated using `ctypes`.

## Prerequisites

- OCaml (>= 4.14.0)
- Dune (>= 3.0)
- `ctypes` and `ctypes-foreign`
- **falcon-core C library**:  
  You must have `libfalcon_core_c_api.so` installed and available in your library path (e.g., `/usr/local/lib`).  
  _Install this via your system package manager or from source. Example for Ubuntu:_  

  ```sh
  sudo cp path/to/libfalcon_core_c_api.so /usr/local/lib/
  sudo ldconfig
  ```

## Installation using opam pin

You can install directly from the GitHub repository:

```sh
opam pin add falcon_core https://github.com/falcon-autotuning/falcon-core-libs.git
```

## Development

### Building

```sh
make build
```

### Running Tests

```sh
make test
```

### Cleaning

```sh
make clean
```

## Release

To create a source distribution tarball for release:

```sh
make dist
```

This creates `falcon_core-ocaml.tar.gz` which can be uploaded as a release asset.

## Usage

In your project's `dune` file:

```lisp
(executable
 (name my_prog)
 (libraries falcon_core))
```

## Notes

- Ensure `libfalcon_core_c_api.so` is installed and discoverable by your system linker before using this package.
- If you encounter linking errors, check your `LD_LIBRARY_PATH` or install the C library to a standard location.
