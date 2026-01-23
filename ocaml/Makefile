# Makefile for OCaml falcon-core bindings

.PHONY: all build test install uninstall clean

all: build

build:
	dune build

test:
	dune runtest

install:
	dune build @install
	opam install .

uninstall:
	opam uninstall falcon_core

dist:
	rm -rf falcon_core-ocaml.tar.gz
	tar -czf falcon_core-ocaml.tar.gz \
		--exclude='_build' \
		--exclude='.git' \
		--exclude='*.tar.gz' \
		.

release: dist

clean:
	dune clean
	rm -f falcon_core-ocaml.tar.gz
