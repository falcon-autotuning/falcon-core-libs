import multiprocessing
import os
import subprocess

from Cython.Build import cythonize
from setuptools import Extension, find_packages, setup

# Get the absolute path to the directory containing this setup.py file
SETUP_DIR = os.path.abspath(os.path.dirname(__file__))


# --- C API Dependencies ---
def pkg_config(variable, pkg="falcon-core-c-api"):
    try:
        result = (
            subprocess.check_output(
                ["pkg-config", "--" + variable, pkg], universal_newlines=True
            )
            .strip()
            .split()
        )
        if not result:
            raise RuntimeError(
                f"pkg-config did not return any result for {variable} of {pkg}"
            )
        return result
    except Exception as e:
        raise RuntimeError(
            f"Could not find {pkg} using pkg-config and no environment override set: {e}"
        )


# Header directory for the pre-built C API library
C_API_INCLUDE_DIR = os.environ.get(
    "FALCON_CORE_INCLUDE", pkg_config("cflags-only-I")[0][2:]
)

# Library directory for the pre-built C API library
C_API_LIB_DIR = os.environ.get("FALCON_CORE_LIB", pkg_config("libs-only-L")[0][2:])
# Name of the C API library to link against
C_API_LIBS = ["falcon-core-c-api"]

# Directory containing the .pyx and .pxd files
CAPI_WRAPPER_DIR = os.path.join(SETUP_DIR, "src", "falcon_core", "_capi")

# Auto-discover all .pyx files in the _capi directory
ext_modules = []
for pyx_file in os.listdir(CAPI_WRAPPER_DIR):
    if pyx_file.endswith(".pyx"):
        module_name = pyx_file[:-4]  # Remove .pyx extension
        ext_modules.append(
            Extension(
                f"falcon_core._capi.{module_name}",
                sources=[os.path.join(CAPI_WRAPPER_DIR, pyx_file)],
                include_dirs=[
                    C_API_INCLUDE_DIR,
                    CAPI_WRAPPER_DIR,
                    os.path.join(SETUP_DIR, "src"),
                ],
                libraries=C_API_LIBS,
                library_dirs=[C_API_LIB_DIR],
                runtime_library_dirs=[C_API_LIB_DIR],
                language="c++",
            )
        )

# Use as many threads as available for cythonization
N_THREADS = multiprocessing.cpu_count()

setup(
    name="falcon_core",
    version="0.0.0",
    packages=find_packages("src"),
    package_dir={"": "src"},
    ext_modules=cythonize(
        ext_modules,
        language_level=3,
        nthreads=N_THREADS,
        include_path=[
            C_API_INCLUDE_DIR,
            CAPI_WRAPPER_DIR,
            os.path.join(SETUP_DIR, "src"),
        ],
    ),
    zip_safe=False,
)
