from setuptools import setup, Extension, find_packages
import os
from Cython.Build import cythonize

INCLUDE_DIR = os.environ.get("FALCON_CORE_INCLUDE", "/usr/local/include/falcon-core-c-api")
LIB_DIR = os.environ.get("FALCON_CORE_LIB", "/usr/local/lib")
LIBS = ["falcon_core_c_api"]

ext_modules = [
    Extension(
        "falcon_core._capi.connection",
        sources=["src/falcon_core/_capi/connection.pyx"],
        include_dirs=[INCLUDE_DIR],
        libraries=LIBS,
        library_dirs=[LIB_DIR],
    )
]

setup(
    name="falcon_core",
    version="0.0.0",
    packages=find_packages("src"),
    package_dir={"": "src"},
    ext_modules=cythonize(ext_modules, language_level=3),
    zip_safe=False,
)
