.PHONY: help clean vcpkg-bootstrap

# Detect the preset from CMAKE_PRESET environment variable or default to linux-clang-release
PRESET ?= linux-clang-release
CMAKE_BUILD_DIR := build/$(PRESET)

help:
	@echo "Falcon Core Libs Build System"
	@echo "========================"
	@echo ""
	@echo "Available presets:"
	@cmake --list-presets=all
	@echo ""
	@echo "Usage:"
	@echo "  make clean                      - Clean all build artifacts"
	@echo ""
	@echo "Or use cmake directly:"
	@echo "  cmake --preset linux-clang-release"
	@echo "  cmake --build --preset linux-clang-release"
	@echo "  ctest --preset linux-clang-release"

vcpkg-bootstrap: 
	@mkdir -p $(CMAKE_BUILD_DIR)
	@echo "Bootstrapping vcpkg..."
	cmake -P cmake/bootstrap/bootstrap-vcpkg.cmake

clean:
	@echo "Cleaning build artifacts and test containers..."
	rm -rf vcpkg_installed 
	@echo "✓ Clean complete"
