#!/usr/bin/env bash
set -euo pipefail

# This script prepares the local Arch Linux development environment.
# It installs system dependencies and falcon-core C-API libraries.

echo "--- Installing system dependencies ---"

# 1. Update package database and install essential packages
sudo pacman -S --noconfirm --needed \
  base-devel git openssh curl \
  python python-pip python-setuptools python-wheel cython \
  cereal hdf5 boost bzip2 expat nlohmann-json \
  sqlite yaml-cpp ninja llvm ccache clang gtest unzip github-cli openmpi

# 2. Download and install falcon-core libraries and headers
REPO="falcon-autotuning/falcon-core"
RELEASE_TAG="v0.0.2"
TMPDIR=$(mktemp -d)

echo "Downloading release assets from ${REPO} (tag: ${RELEASE_TAG}) to ${TMPDIR}..."

gh release download "${RELEASE_TAG}" --repo "${REPO}" --dir "${TMPDIR}" \
  -p "libfalcon_core_c_api.so" \
  -p "libfalcon_core_cpp.so" \
  -p "falcon-core-c-api-headers.zip" || {
  echo "ERROR: Failed to download release assets. Ensure you are logged in to 'gh' and have access." >&2
  exit 1
}

# Install shared libraries
echo "Installing libraries to /usr/local/lib..."
sudo install -Dm755 "${TMPDIR}/libfalcon_core_c_api.so" /usr/local/lib/libfalcon_core_c_api.so
sudo install -Dm755 "${TMPDIR}/libfalcon_core_cpp.so" /usr/local/lib/libfalcon_core_cpp.so

# Install headers
echo "Installing headers to /usr/local/include/falcon-core-c-api..."
unzip -q -o "${TMPDIR}/falcon-core-c-api-headers.zip" -d "${TMPDIR}/headers"
sudo install -d /usr/local/include/falcon-core-c-api
sudo cp -r "${TMPDIR}/headers/include/"* /usr/local/include/falcon-core-c-api/

# Ensure the linker knows about /usr/local/lib
if [ ! -f /etc/ld.so.conf.d/99-local.conf ] || ! grep -q "/usr/local/lib" /etc/ld.so.conf.d/99-local.conf; then
    echo "Adding /usr/local/lib to ldconfig..."
    echo "/usr/local/lib" | sudo tee /etc/ld.so.conf.d/99-local.conf > /dev/null
fi

# Update linker cache
sudo ldconfig
echo "falcon-core C-API library and headers installed."

# 3. HDF5 compatibility symlinks
# The pre-built libraries might be linked against an older version of HDF5.
# Check what we have and create symlinks if necessary.
HDF5_VER=$(pacman -Q hdf5 | awk '{print $2}' | cut -d- -f1)
echo "Current HDF5 version: ${HDF5_VER}"

# The libraries expect .310, check if we need to link them from .320 or whatever versioned lib we have.
CURRENT_LIBHDF5=$(ls /usr/lib/libhdf5.so.[0-9]* | grep -v "libhdf5.so.310" | head -n 1)
if [ -n "${CURRENT_LIBHDF5}" ] && [ ! -f /usr/lib/libhdf5.so.310 ]; then
    VERSION_EXT="${CURRENT_LIBHDF5##*.so.}"
    echo "Creating HDF5 compatibility symlinks (from .${VERSION_EXT} to .310)..."
    sudo ln -sf "/usr/lib/libhdf5_cpp.so.${VERSION_EXT}" /usr/lib/libhdf5_cpp.so.310
    sudo ln -sf "/usr/lib/libhdf5.so.${VERSION_EXT}" /usr/lib/libhdf5.so.310
    sudo ln -sf "/usr/lib/libhdf5_hl_cpp.so.${VERSION_EXT}" /usr/lib/libhdf5_hl_cpp.so.310
    sudo ln -sf "/usr/lib/libhdf5_hl.so.${VERSION_EXT}" /usr/lib/libhdf5_hl.so.310
fi

# Cleanup
rm -rf "${TMPDIR}"

echo "--- Setup complete ---"
