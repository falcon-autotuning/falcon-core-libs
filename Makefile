REPO = falcon-autotuning/falcon-core
RELEASE_TAG = v0.0.1
TMPDIR = /tmp/falcon-core-install
LIBDIR = /usr/local/lib
INCLUDEDIR = /usr/local/include
PCDIR = /usr/local/lib/pkgconfig

prefix ?= /usr/local
exec_prefix ?= $(prefix)
libdir ?= $(exec_prefix)/lib
includedir ?= $(prefix)/include/falcon-core-c-api

PC_NAME := falcon_core_c_api.pc
PC_IN := falcon_core_c_api.pc.in
PC_OUT := $(TMPDIR)/$(PC_NAME)

.PHONY: all clean install uninstall pkgconfig

all: install

install: install_libs pkgconfig

install_libs:
	@echo "Fetching latest release assets with gh..."
	mkdir -p $(TMPDIR)
	cd $(TMPDIR) && \
	  gh release download $(RELEASE_TAG) --repo $(REPO) \
	    -p "libfalcon_core_cpp.so" \
	    -p "libfalcon_core_c_api.so" \
	    -p "falcon-core-cpp-headers.zip" \
	    -p "falcon-core-c-api-headers.zip"
	@echo "Installing shared libraries..."
	sudo install -Dm755 $(TMPDIR)/libfalcon_core_cpp.so $(LIBDIR)/libfalcon_core_cpp.so
	sudo install -Dm755 $(TMPDIR)/libfalcon_core_c_api.so $(LIBDIR)/libfalcon_core_c_api.so
	@echo "Extracting and installing C++ headers..."
	mkdir -p $(TMPDIR)/cpp_headers
	unzip -q -o $(TMPDIR)/falcon-core-cpp-headers.zip -d $(TMPDIR)/cpp_headers
	sudo mkdir -p $(INCLUDEDIR)/falcon-core-cpp
	sudo cp -r $(TMPDIR)/cpp_headers/include/* $(INCLUDEDIR)/falcon-core-cpp/
	@echo "Extracting and installing C API headers..."
	mkdir -p $(TMPDIR)/c_api_headers
	unzip -q -o $(TMPDIR)/falcon-core-c-api-headers.zip -d $(TMPDIR)/c_api_headers
	sudo mkdir -p $(INCLUDEDIR)/falcon-core-c-api
	sudo cp -r $(TMPDIR)/c_api_headers/include/* $(INCLUDEDIR)/falcon-core-c-api/
	@echo "Updating linker cache..."
	sudo ldconfig
	@echo "falcon-core libraries and headers installed successfully."
	@echo ""

pkgconfig: $(PC_OUT)
	@echo "Installing pkg-config file to $(PCDIR)"
	sudo install -Dm644 $(PC_OUT) $(PCDIR)/$(PC_NAME)
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
	@echo "Removing shared libraries..."
	sudo rm -f /usr/local/lib/libfalcon_core_cpp.so
	sudo rm -f /usr/local/lib/libfalcon_core_c_api.so
	@echo "Removing header directories..."
	sudo rm -rf /usr/local/include/falcon-core-cpp
	sudo rm -rf /usr/local/include/falcon-core-c-api
	@echo "Removing pkg-config file..."
	sudo rm -f /usr/local/lib/pkgconfig/falcon_core_c_api.pc
	@echo "Updating linker cache..."
	sudo ldconfig
	@echo "falcon-core libraries, headers, and pkg-config file uninstalled successfully."
	@echo ""
	@echo "If you set PKG_CONFIG_PATH for falcon_core_c_api, you may remove it from your shell profile."

clean:
	rm -rf $(TMPDIR)
