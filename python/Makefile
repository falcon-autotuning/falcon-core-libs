# Platform detection (works on Linux, MINGW/MSYS, and native Windows)
UNAME_S := $(shell uname -s 2>/dev/null || echo Unknown)
IS_MINGW := $(findstring MINGW,$(UNAME_S))
IS_CYGWIN := $(findstring CYGWIN,$(UNAME_S))
IS_WINDOWS_NT := $(filter Windows_NT,$(OS))
GENERATED_MANIFEST := generated_template_manifest.txt
ifeq ($(or $(IS_MINGW),$(IS_CYGWIN),$(IS_WINDOWS_NT)),)
  PLATFORM := linux
else
  PLATFORM := windows
endif

# Default compilers (user can override from environment)
ifeq ($(PLATFORM),windows)
  # prefer clang-cl when available; user can pass CC/ CXX to override
  CC ?= clang-cl
	CXX ?= clang-cl
  CMAKE_GENERATOR := Ninja
  VCPKG_TRIPLET := x64-windows
  VCPKG_DEBUG_BIN := $(PWD)/vcpkg_installed/x64-windows/bin
  VCPKG_RELEASE_LIB := $(PWD)/vcpkg_installed/x64-windows/lib
  EXE_SUFFIX := .exe
	NPROC := $(shell powershell -Command "[Environment]::ProcessorCount" 2>NUL || echo 4)
  STRIP_CMD := # no-op (strip not usually present); set to "llvm-strip" if you have it
	RUN_PREFIX := PATH=$(VCPKG_DEBUG_BIN):$(VCPKG_RELEASE_LIB):$$PATH
	SUDO ?= sudo
  PYTHON_EXECUTABLE ?= python
  # On Windows, Ninja + clang-cl: still pass CMAKE_C_COMPILER / CMAKE_CXX_COMPILER
else
  CMAKE_GENERATOR := Ninja
  VCPKG_TRIPLET := x64-linux-dynamic
  VCPKG_DEBUG_LIB := $(PWD)/vcpkg_installed/x64-linux-dynamic/debug/lib
  VCPKG_RELEASE_LIB := $(PWD)/vcpkg_installed/x64-linux-dynamic/lib
  EXE_SUFFIX :=
  NPROC := $(shell nproc 2>/dev/null || echo 4)
  STRIP_CMD := strip
	RUN_PREFIX := LD_LIBRARY_PATH=$(VCPKG_DEBUG_LIB):$(VCPKG_RELEASE_LIB):$$LD_LIBRARY_PATH
	SUDO :=
	PYTHON_EXECUTABLE ?= python3
	export CC=clang
	export CXX=clang++
endif
VCPKG_INSTALLED_DIR ?= $(CURDIR)/../vcpkg_installed

install:
	uv venv --clear
	uv pip install Cython setuptools pytest coverage
	LD_LIBRARY_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib:$$LD_LIBRARY_PATH \
	PKG_CONFIG_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib/pkgconfig:$$PKG_CONFIG_PATH \
	uv pip install -e .

test:
	LD_LIBRARY_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib:$$LD_LIBRARY_PATH \
	PKG_CONFIG_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib/pkgconfig:$$PKG_CONFIG_PATH \
	uv run pytest --tb=short

coverage:
	LD_LIBRARY_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib:$$LD_LIBRARY_PATH \
	PKG_CONFIG_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib/pkgconfig:$$PKG_CONFIG_PATH \
	uv run python run_coverage.py

wheel:
	LD_LIBRARY_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib:$$LD_LIBRARY_PATH \
	PKG_CONFIG_PATH=$(VCPKG_INSTALLED_DIR)/$(VCPKG_TRIPLET)/lib/pkgconfig:$$PKG_CONFIG_PATH \
	uv build --wheel
