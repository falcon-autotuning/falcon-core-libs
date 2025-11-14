#!/usr/bin/env bash
set -euo pipefail

# This entrypoint prepares an interactive Arch dev container similar to the CI job.
# It installs required packages, downloads falcon-core release artifacts (using gh),
# installs the shared libraries and headers to /usr/local, runs ldconfig, then drops
# into an interactive shell as builduser.
#
# Note: For private releases, ensure the container has GH auth:
# - Either export GITHUB_TOKEN when running docker-compose, or
# - Use 'gh auth login' before running this script (interactive), or
# - Make sure your host's gh auth config is mounted into the container.
#
# SSH agent forwarding is supported via mounting your host SSH_AUTH_SOCK into the container
# (docker-compose.yml maps it to /ssh-agent and sets SSH_AUTH_SOCK accordingly).

REPO="${REPO:-falcon-autotuning/falcon-core}"
RELEASE_TAG="${RELEASE_TAG:-v0.0.1}"
TMPDIR="/tmp/falcon-core-release"

echo "Preparing arch dev container (REPO=${REPO}, RELEASE_TAG=${RELEASE_TAG})"

# Update and install packages
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
  base-devel git openssh cereal hdf5 boost bzip2 expat nlohmann-json \
  openssl python python-pip python-setuptools python-wheel cython \
  sqlite yaml-cpp zlib ninja llvm ccache clang gtest unzip sudo github-cli curl

# Create builduser if missing and allow passwordless sudo
if ! id -u builduser >/dev/null 2>&1; then
  useradd -m builduser
fi
if ! grep -q '^builduser ALL=(ALL) NOPASSWD: ALL' /etc/sudoers 2>/dev/null; then
  echo "builduser ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers
fi

# Force clang as default for makepkg builds (persist)
if grep -q '^CC=' /etc/makepkg.conf 2>/dev/null; then
  sed -i 's|^CC=.*|CC=/usr/bin/clang|' /etc/makepkg.conf || true
else
  echo 'CC=/usr/bin/clang' >>/etc/makepkg.conf
fi
if grep -q '^CXX=' /etc/makepkg.conf 2>/dev/null; then
  sed -i 's|^CXX=.*|CXX=/usr/bin/clang++|' /etc/makepkg.conf || true
else
  echo 'CXX=/usr/bin/clang++' >>/etc/makepkg.conf
fi

# Prepare temporary download dir
rm -rf "${TMPDIR}"
mkdir -p "${TMPDIR}"
cd "${TMPDIR}"

# Use gh to download release assets. Requires gh authentication for private repos.
echo "Downloading release assets with gh..."
gh release download "${RELEASE_TAG}" --repo "${REPO}" \
  -p "libfalcon_core_cpp.so" \
  -p "libfalcon_core_c_api.so" \
  -p "falcon-core-cpp-headers.zip" \
  -p "falcon-core-c-api-headers.zip" || {
  echo "gh release download failed. Ensure gh is authenticated (GITHUB_TOKEN or gh auth login)."
  exit 1
}

# Install shared libraries
if [ -f libfalcon_core_cpp.so ]; then
  install -Dm755 libfalcon_core_cpp.so /usr/local/lib/libfalcon_core_cpp.so
fi
if [ -f libfalcon_core_c_api.so ]; then
  install -Dm755 libfalcon_core_c_api.so /usr/local/lib/libfalcon_core_c_api.so
fi

# Extract and install headers
if [ -f falcon-core-cpp-headers.zip ]; then
  mkdir -p /tmp/cpp_headers
  unzip -q -o falcon-core-cpp-headers.zip -d /tmp/cpp_headers
  mkdir -p /usr/local/include/falcon-core-cpp
  cp -r /tmp/cpp_headers/include/* /usr/local/include/falcon-core-cpp/ || true
fi

if [ -f falcon-core-c-api-headers.zip ]; then
  mkdir -p /tmp/c_api_headers
  unzip -q -o falcon-core-c-api-headers.zip -d /tmp/c_api_headers
  mkdir -p /usr/local/include/falcon-core-c-api
  cp -r /tmp/c_api_headers/include/* /usr/local/include/falcon-core-c-api/ || true
fi

# Update linker cache so installed .so files are discoverable
ldconfig

# Ensure workdir exists and is owned by builduser (compose mounts repo at /workdir)
if [ ! -d /workdir ]; then
  mkdir -p /workdir
fi
chown -R builduser:builduser /workdir || true

echo "Preparation complete. Installed libs:"
ls -l /usr/local/lib/libfalcon_core* 2>/dev/null || true
echo "Installed headers directories:"
ls -d /usr/local/include/falcon-core* 2>/dev/null || true

# Install uv (user installer) for builduser if not present
if ! sudo -u builduser -H bash -lc 'command -v uv >/dev/null 2>&1'; then
  echo "Installing uv for builduser..."
  # make sure user-local dirs exist and are owned
  mkdir -p /home/builduser/.local/bin
  chown -R builduser:builduser /home/builduser/.local || true

  # Run installer as builduser and capture output
  if ! sudo -u builduser env HOME=/home/builduser bash -lc 'curl -LsSf https://astral.sh/uv/install.sh 2>&1 | tee /tmp/uv-install.log | sh'; then
    echo "uv installer failed; dumping /tmp/uv-install.log:"
    sed -n '1,200p' /tmp/uv-install.log || true
    exit 1
  fi

  # Ensure PATH available in login shells for the builduser
  cat >/etc/profile.d/uv.sh <<'EOF'
# ensure user-local bin is available for builduser
export PATH="/home/builduser/.local/bin:$PATH"
EOF
  chmod 644 /etc/profile.d/uv.sh
fi

# Drop to an interactive shell as builduser (preserve SSH agent socket via env)
export SSH_AUTH_SOCK=/ssh-agent
exec /usr/bin/sudo -E -u builduser /bin/bash --login
