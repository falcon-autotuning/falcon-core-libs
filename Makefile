# Repo and release configuration
REPO = falcon-autotuning/falcon-core
RELEASE_TAG = v1.1.0
LIBS_RELEASE_TAG = v0.0.2
LIBS_REPO = falcon-autotuning/falcon-core-libs

# GitHub release download base URL
GITHUB_RELEASE_URL = https://github.com/$(REPO)/releases/download/$(RELEASE_TAG)

# OS detection
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
  TMPDIR = /tmp/falcon-core-install
  LIBDIR = /opt/falcon/lib
  INCLUDEDIR = /opt/falcon/include
  PCDIR = /opt/falcon/lib/pkgconfig
  SUDO ?= sudo
  ARCHIVE_CPP = falcon-core-cpp-linux-x64.tar.gz
  ARCHIVE_CPP_SHA = falcon-core-cpp-linux-x64.tar.gz.sha256
  ARCHIVE_CAPI = falcon-core-c-api-linux-x64.tar.gz
  ARCHIVE_CAPI_SHA = falcon-core-c-api-linux-x64.tar.gz.sha256
  EXTRACT_CPP = tar -xzf $(TMPDIR)/$(ARCHIVE_CPP) -C $(TMPDIR)/cpp
  EXTRACT_CAPI = tar -xzf $(TMPDIR)/$(ARCHIVE_CAPI) -C $(TMPDIR)/c_api
  LIBSUBDIR = lib
else
  # Assume Windows (Git Bash)
  USERPROFILE := $(shell echo $$USERPROFILE | tr '\\' '/')
  TMPDIR = $(USERPROFILE)/AppData/Local/Temp/falcon-core-install
  LIBDIR = $(USERPROFILE)/AppData/Local/falcon/lib
  INCLUDEDIR = $(USERPROFILE)/AppData/Local/falcon/include
  PCDIR = $(USERPROFILE)/AppData/Local/falcon/lib/pkgconfig
  SUDO =
  ARCHIVE_CPP = falcon-core-cpp-windows-x64.zip
  ARCHIVE_CPP_SHA := $(shell echo falcon-core-cpp-windows-x64.zip.sha256 | tr -d '\r')
  ARCHIVE_CAPI = falcon-core-c-api-windows-x64.zip
  ARCHIVE_CAPI_SHA := $(shell echo falcon-core-c-api-windows-x64.zip.sha256 | tr -d '\r')
  EXTRACT_CPP = unzip -o $(TMPDIR)/$(ARCHIVE_CPP) -d $(TMPDIR)/cpp
  EXTRACT_CAPI = unzip -o $(TMPDIR)/$(ARCHIVE_CAPI) -d $(TMPDIR)/c_api
  LIBSUBDIR = bin
endif

prefix ?= $(LIBDIR)
exec_prefix ?= $(prefix)
libdir ?= $(exec_prefix)
includedir ?= $(INCLUDEDIR)/falcon-core-c-api

PC_NAME := falcon_core_c_api.pc
PC_IN := falcon_core_c_api.pc.in
PC_OUT := $(TMPDIR)/$(PC_NAME)

.PHONY: all clean install uninstall pkgconfig

all: install

install: install_libs pkgconfig

install_libs:
	@echo "Fetching latest release assets from GitHub..."
	mkdir -p $(TMPDIR)
	$(SUDO) mkdir -p $(prefix)
	$(SUDO) mkdir -p $(LIBDIR)
	$(SUDO) mkdir -p $(INCLUDEDIR)
	@echo "Downloading $(ARCHIVE_CPP)..."
	curl -L -f -o $(TMPDIR)/$(ARCHIVE_CPP) \
		$(GITHUB_RELEASE_URL)/$(ARCHIVE_CPP)
	@echo "Downloading $(ARCHIVE_CPP_SHA)..."
	curl -L -f -o $(TMPDIR)/$(ARCHIVE_CPP_SHA) \
		$(GITHUB_RELEASE_URL)/$(ARCHIVE_CPP_SHA)
	@echo "Downloading $(ARCHIVE_CAPI)..."
	curl -L -f -o $(TMPDIR)/$(ARCHIVE_CAPI) \
		$(GITHUB_RELEASE_URL)/$(ARCHIVE_CAPI)
	@echo "Downloading $(ARCHIVE_CAPI_SHA)..."
	curl -L -f -o $(TMPDIR)/$(ARCHIVE_CAPI_SHA) \
		$(GITHUB_RELEASE_URL)/$(ARCHIVE_CAPI_SHA)
ifeq ($(findstring MINGW,$(UNAME_S)),MINGW)
	dos2unix "$(TMPDIR)/falcon-core-cpp-windows-x64.zip.sha256"
	dos2unix "$(TMPDIR)/falcon-core-c-api-windows-x64.zip.sha256"
endif
	@echo "Verifying checksums..."
	cd "$(TMPDIR)" && sha256sum -c "$(shell echo $(ARCHIVE_CPP_SHA) | tr -d '\r')"
	cd "$(TMPDIR)" && sha256sum -c "$(shell echo $(ARCHIVE_CAPI_SHA) | tr -d '\r')"
	@echo "Extracting Archives..."
	mkdir -p $(TMPDIR)/cpp
	mkdir -p $(TMPDIR)/c_api
	$(EXTRACT_CPP)
	$(EXTRACT_CAPI)
	@echo "Installing Shared Libraries..."
	$(SUDO) install -Dm755 $(TMPDIR)/cpp/$(LIBSUBDIR)/* $(LIBDIR)/
	$(SUDO) install -Dm755 $(TMPDIR)/c_api/$(LIBSUBDIR)/* $(LIBDIR)/
	@echo "Extracting and Installing C++ Headers..."
	$(SUDO) mkdir -p $(INCLUDEDIR)/falcon-core-cpp/falcon_core/
	$(SUDO) cp -r $(TMPDIR)/cpp/include/falcon_core/* $(INCLUDEDIR)/falcon-core-cpp/falcon_core/
	@echo "Extracting and Installing C API Headers..."
	$(SUDO) mkdir -p $(INCLUDEDIR)/falcon-core-c-api/falcon_core/
	$(SUDO) cp -r $(TMPDIR)/c_api/include/falcon_core/* $(INCLUDEDIR)/falcon-core-c-api/falcon_core/
	@echo "Installing other Headers..."
	$(SUDO) find $(TMPDIR)/cpp/include -mindepth 1 -maxdepth 1 ! -name 'falcon_core' -exec cp -r {} $(INCLUDEDIR)/ \;
	$(SUDO) find $(TMPDIR)/c_api/include -mindepth 1 -maxdepth 1 ! -name 'falcon_core' -exec cp -r {} $(INCLUDEDIR)/ \;
ifeq ($(UNAME_S),Linux)
	@echo "Updating linker cache..."
	$(SUDO) ldconfig
endif
	@echo "falcon-core libraries and headers installed successfully."
	@echo ""

pkgconfig: $(PC_OUT)
	@echo "Installing pkg-config file to $(PCDIR)"
	$(SUDO) install -Dm644 $(PC_OUT) $(PCDIR)/$(PC_NAME)
	@echo "If pkg-config cannot find falcon_core_c_api, add this to your shell profile:"
	@echo "  export PKG_CONFIG_PATH=$(PCDIR):\$$PKG_CONFIG_PATH"

$(PC_OUT): $(PC_IN)
	@echo "Generating pkg-config file from template"
	mkdir -p $(TMPDIR)
	sed \
		-e "s|@prefix@|$(prefix)|g" \
		-e "s|@exec_prefix@|$(exec_prefix)|g" \
		-e "s|@libdir@|$(libdir)|g" \
		-e "s|@includedir@|$(includedir)|g" \
		$< > $@

uninstall:
	@echo "Removing..."
	$(SUDO) rm -rf /opt/falcon/
	@echo "Updating linker cache..."
	$(SUDO) ldconfig
	@echo "falcon-core libraries, headers, and pkg-config file uninstalled successfully."
	@echo ""
	@echo "If you set PKG_CONFIG_PATH for falcon_core_c_api, you may remove it from your shell profile."

clean:
	rm -rf $(TMPDIR)

wheel:
	$(MAKE) -C python wheel

python-release-upload: wheel
	@echo "Uploading Python wheel to GitHub release $(LIBS_RELEASE_TAG)..."
	gh release upload $(LIBS_RELEASE_TAG) --repo $(LIBS_REPO) --clobber \
		python/dist/falcon_core-0.0.0-cp314-cp314-linux_x86_64.whl

ocaml-release-upload:
	$(MAKE) -C ocaml release
	@echo "Uploading OCaml source distribution to GitHub release $(LIBS_RELEASE_TAG)..."
	gh release upload $(LIBS_RELEASE_TAG) --repo $(LIBS_REPO) --clobber \
		ocaml/falcon_core-ocaml.tar.gz

prepare-go-release:
	rm -rf out && mkdir -p out
	cd go && zip -r ../out/falcon-core-go.zip falcon-core -x "falcon-core/.git/*" "falcon-core/.cache/*" "falcon-core/vendor/*" "falcon-core/testdata/*"
