# Falcon Core Libs

Bindings of falcon-core in useful programming languages.
All of the languages are bound to the C-API from falcon-core.

The generated code falls under the same license as falcon-core itself, which is the BSD-3-Clause License.
We have included a copy of the license in the `LICENSE` file.

# Go bindings
The falcon-core language bindings for Go are located in the `go/falcon-core' directory.
When installing this package, make sure you have falcon-core installed on your system.
The go package is setup to to require a pkg-config installed somehere on your system. This pkg-config contains all of the locations of the header files and the shared library for falcon-core.
We recommend installing falcon-core at tmp/local/ such that the pkg-config file is located at `tmp/local/lib/pkgconfig/falcon-core.pc'.
We have a makefile setup for that can be accessed via 'make install'
