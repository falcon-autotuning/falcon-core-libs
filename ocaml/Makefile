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

clean:
	dune clean
