REPO = falcon-autotuning/falcon-core
RELEASE_TAG = v0.0.1
TMPDIR = /tmp/falcon-core-install
LIBDIR = /usr/local/lib
INCLUDEDIR = /usr/local/include

.PHONY: all clean install uninstall

all: install

install:
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

uninstall:
	@echo "Removing shared libraries..."
	sudo rm -f /usr/local/lib/libfalcon_core_cpp.so
	sudo rm -f /usr/local/lib/libfalcon_core_c_api.so
	@echo "Removing header directories..."
	sudo rm -rf /usr/local/include/falcon-core-cpp
	sudo rm -rf /usr/local/include/falcon-core-c-api
	@echo "Updating linker cache..."
	sudo ldconfig

	@echo "falcon-core libraries and headers uninstalled successfully."

clean:
	rm -rf $(TMPDIR)
