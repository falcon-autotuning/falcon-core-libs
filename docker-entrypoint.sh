#!/usr/bin/env bash
set -euo pipefail

# This entrypoint script prepares an interactive Arch Linux development container.
# It runs as root to set up the system, then drops into a shell as the 'daniel' user.

echo "--- Preparing Arch Linux development environment ---"

# 1. Update package database and install essential packages
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
  base-devel git openssh sudo curl \
  python python-pip python-setuptools python-wheel cython \
  cereal hdf5 boost bzip2 expat nlohmann-json \
  sqlite yaml-cpp zlib ninja llvm ccache clang gtest unzip github-cli

# 2. Create the 'daniel' user with passwordless sudo
if ! id -u daniel >/dev/null 2>&1; then
  echo "Creating user 'daniel'..."
  # Create user with a home directory and add to 'wheel' group for sudo
  useradd -m -G wheel daniel
fi
# Grant passwordless sudo to members of the 'wheel' group
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99-wheel-nopasswd
chmod 0440 /etc/sudoers.d/99-wheel-nopasswd

# Set correct ownership for the user's home directory before running commands as the user.
# The volume mount for .ssh is read-only, so chown would fail on it. We handle this by
# changing ownership of the parent first, then selectively chowning its contents to avoid
# the read-only .ssh mount.
chown daniel:daniel /home/daniel
find /home/daniel -mindepth 1 -maxdepth 1 ! -name .ssh -exec chown -R daniel:daniel {} +

# 3. Install 'uv' Python package manager for the 'daniel' user
if ! sudo -u daniel -H bash -c 'command -v uv >/dev/null 2>&1'; then
  echo "Installing 'uv' for user 'daniel'..."
  # The installer script will place 'uv' in /home/daniel/.local/bin/uv
  sudo -u daniel -H bash -c "curl -LsSf https://astral.sh/uv/install.sh | sh"
fi

# 4. Download and install falcon-core libraries and headers
REPO="falcon-autotuning/falcon-core"
RELEASE_TAG="v0.0.1"
TMPDIR="/tmp/falcon-core-release"

rm -rf "${TMPDIR}"
mkdir -p "${TMPDIR}"

echo "Downloading release assets from ${REPO} (tag: ${RELEASE_TAG})..."
gh release download "${RELEASE_TAG}" --repo "${REPO}" --dir "${TMPDIR}" \
  -p "libfalcon_core_c_api.so" \
  -p "libfalcon_core_cpp.so" \
  -p "falcon-core-c-api-headers.zip" || {
  echo "ERROR: Failed to download release assets. Ensure GH_TOKEN is valid." >&2
  exit 1
}

# Install shared libraries
install -Dm755 "${TMPDIR}/libfalcon_core_c_api.so" /usr/local/lib/libfalcon_core_c_api.so
install -Dm755 "${TMPDIR}/libfalcon_core_cpp.so" /usr/local/lib/libfalcon_core_cpp.so

# Install headers
unzip -q -o "${TMPDIR}/falcon-core-c-api-headers.zip" -d "${TMPDIR}/headers"
install -d /usr/local/include/falcon-core-c-api
cp -r "${TMPDIR}/headers/include/"* /usr/local/include/falcon-core-c-api/

# Ensure the linker knows about /usr/local/lib
echo "/usr/local/lib" > /etc/ld.so.conf.d/99-local.conf

# Update linker cache to make the new library available
ldconfig
echo "falcon-core C-API library and headers installed."

# 5. Set correct ownership for the work directory
chown -R daniel:daniel /workdir

echo "--- Setup complete. Dropping into shell as user 'daniel' ---"

# 6. Switch to the 'daniel' user and start a login shell
# Using 'exec' replaces the current process with the new one.
# 'su -l' ensures a clean login environment, including sourcing profile scripts.
exec su -l daniel
