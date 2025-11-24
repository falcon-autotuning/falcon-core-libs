export CC=clang
export CXX=clang++

TESTDIR ?= ./physics/deviceStructures/connection
TESTNAME ?= TestConnection_ErrorOnClosed

.PHONY: all build test

all: build

gen-lists:
	go run tools/genList/main.go

gen-pairs:
	go run tools/genPair/main.go

gen-farray:
	go run tools/genFarray/main.go

gen-maps:
	go run tools/genMap/main.go

gen-axes:
	go run tools/genAxes/main.go

gen-labelledarrays:
	go run tools/genLabelledArrays/main.go

gen-interpretationcontainer:
	go run tools/genInterpretationContainer/main.go

gen: gen-lists gen-pairs gen-farray gen-maps gen-axes gen-labelledarrays gen-interpretationcontainer

build: gen
	go build ./...

func-coverage:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH go test -coverprofile=c.out -covermode=count $(shell go list ./... | grep -v '^./tools') && go tool cover -func=c.out

line-coverage:
	go test -coverprofile=c.out -covermode=count ./...
	go tool cover -html=c.out -o coverage.html
	xdg-open coverage.html

find-not-wrapped:
	go run ./tools/wrapCoverage/

debug:
	cd $(TESTDIR) && \
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH go test -c -o testbin && \
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH gdb -ex "run -test.v -test.run $(TESTNAME)" ./testbin

clean-gen-lists:
	@if [ -f list_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < list_handles_manifest.txt; \
		rm -f list_handles_manifest.txt; \
	fi

clean-gen-labelledarrays:
	@if [ -f labelledarrays_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < labelledarrays_handles_manifest.txt; \
		rm -f labelledarrays_handles_manifest.txt; \
	fi

clean-gen-axes:
	@if [ -f axes_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < axes_handles_manifest.txt; \
		rm -f axes_handles_manifest.txt; \
	fi

clean-gen-maps:
	@if [ -f map_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < map_handles_manifest.txt; \
		rm -f map_handles_manifest.txt; \
	fi

clean-gen-interpretationcontainer:
	@if [ -f interpretationcontainer_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < interpretationcontainer_handles_manifest.txt; \
		rm -f interpretationcontainer_handles_manifest.txt; \
	fi

clean-gen-farray:
	@if [ -f farray_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < farray_handles_manifest.txt; \
		rm -f farray_handles_manifest.txt; \
	fi

clean-gen-pairs:
	@if [ -f pair_handles_manifest.txt ]; then \
		while read -r file; do \
			rm -f "$$file"; \
		done < pair_handles_manifest.txt; \
		rm -f pair_handles_manifest.txt; \
	fi

make clean: clean-gen-lists clean-gen-labelledarrays clean-gen-axes clean-gen-maps clean-gen-interpretationcontainer clean-gen-farray clean-gen-pairs

test-traceback:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH GOTRACEBACK=crash go test -v  ./...
