Initial Cython port starter files added.

What I added:
- pyproject.toml: minimal build-system declaration (setuptools + cython).
- setup.py: builds a single Cython extension falcon_core._capi.connection and reads include/lib dirs from env vars:
    FALCON_CORE_INCLUDE (default /usr/local/include/falcon-core-c-api)
    FALCON_CORE_LIB     (default /usr/local/lib)
  The extension links against libfalcon_core_c_api (library name 'falcon_core_c_api').

- src/falcon_core/_capi/c_api.pxd: low-level extern declarations reflecting the Connection C API header.
- src/falcon_core/_capi/connection.pyx: thin Cython wrapper (Connection cdef class) that owns the C handle and exposes factory methods and accessors.
- src/falcon_core/physics/device_structures/__init__.py: a small Python-level wrapper delegating to the compiled Cython class.
- tests/test_connection.py: pytest tests that mirror a couple of the Go tests; they skip if the extension is not built or fails to load.
- src/falcon_core/__init__.py: package init.
- CYTHON_PORT_NOTES.md (this file): short notes and suggested commands.

Suggested commands:
python -m pip install -e .
pytest -q

Notes and next steps:
- If the C headers/libs are not installed in the defaults, set environment variables before install, e.g.:
  export FALCON_CORE_INCLUDE=/path/to/include
  export FALCON_CORE_LIB=/path/to/lib

- CI: make the build step install the native falcon-core C libraries (your existing Makefile can be used on Linux CI runners) before building the wheel or running pytest.

- String handling: the wrapper assumes the C API returns NUL-terminated strings that remain valid for immediate read; we convert to Python bytes and decode. If the C API returns heap-allocated strings that must be freed, we will need to call the matching free function from the C API.

- Ownership: Connection.__dealloc__ calls Connection_destroy; be careful not to double-free if the same handle is wrapped twice.

If you want, I can now:
- add more bindings (full surface of the Connection API),
- add type stubs (.pyi) for the public Python wrapper,
- modify setup.py to produce manylinux wheels via cibuildwheel,
- or adapt the pyx/pxd to match any header differences you provide.
