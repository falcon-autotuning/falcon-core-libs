# Makefile for OCaml falcon-core bindings

.PHONY: all build test install uninstall clean

all: build

build:
	dune build

test:
	dune runtest

dist:
	rm -rf falcon_core-ocaml.tar.gz
	tar -czf /tmp/falcon_core-ocaml.tar.gz \
		--exclude='_build' \
		--exclude='.git' \
		--exclude='*.tar.gz' \
		.
	mv /tmp/falcon_core-ocaml.tar.gz .

release: dist

clean:
	dune clean
	rm -f falcon_core-ocaml.tar.gz
