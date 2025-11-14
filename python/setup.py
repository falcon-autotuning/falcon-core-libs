from setuptools import setup, Extension, find_packages
import os
from Cython.Build import cythonize

# Get the absolute path to the directory containing this setup.py file
SETUP_DIR = os.path.abspath(os.path.dirname(__file__))

# --- C API Dependencies ---
# Header directory for the pre-built C API library
C_API_INCLUDE_DIR = os.environ.get(
    "FALCON_CORE_INCLUDE", "/usr/local/include/falcon-core-c-api"
)
# Library directory for the pre-built C API library
C_API_LIB_DIR = os.environ.get("FALCON_CORE_LIB", "/usr/local/lib")
# Name of the C API library to link against
C_API_LIBS = ["falcon_core_c_api"]

# --- Cython Extension Module ---
# Directory containing the .pyx and .pxd files
CAPI_WRAPPER_DIR = os.path.join(SETUP_DIR, "src", "falcon_core", "_capi")

ext_modules = [
    Extension(
        "falcon_core._capi.connection",
        sources=[os.path.join(CAPI_WRAPPER_DIR, "connection.pyx")],
        include_dirs=[C_API_INCLUDE_DIR, CAPI_WRAPPER_DIR],
        libraries=C_API_LIBS,
        library_dirs=[C_API_LIB_DIR],
        runtime_library_dirs=[C_API_LIB_DIR],
        language="c++",
    ),
    Extension(
        "falcon_core._capi.list_int",
        sources=[os.path.join(CAPI_WRAPPER_DIR, "list_int.pyx")],
        include_dirs=[C_API_INCLUDE_DIR, CAPI_WRAPPER_DIR],
        libraries=C_API_LIBS,
        library_dirs=[C_API_LIB_DIR],
        runtime_library_dirs=[C_API_LIB_DIR],
        language="c++",
    ),
    Extension(
        "falcon_core._capi.list_connection",
        sources=[os.path.join(CAPI_WRAPPER_DIR, "list_connection.pyx")],
        include_dirs=[C_API_INCLUDE_DIR, CAPI_WRAPPER_DIR],
        libraries=C_API_LIBS,
        library_dirs=[C_API_LIB_DIR],
        runtime_library_dirs=[C_API_LIB_DIR],
        language="c++",
    ),
]

setup(
    name="falcon_core",
    version="0.0.0",
    packages=find_packages("src"),
    package_dir={"": "src"},
    ext_modules=cythonize(ext_modules, language_level=3),
    zip_safe=False,
)
