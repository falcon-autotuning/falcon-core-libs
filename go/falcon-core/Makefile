export CC=clang
export CXX=clang++

.PHONY: all build test

all: build

gen-lists:
	go run genList.go

build:
	go build ./...

func-coverage:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH go test -coverprofile=c.out -covermode=count ./... && go tool cover -func=c.out

line-coverage:
	go test -coverprofile=c.out -covermode=count ./...
	go tool cover -html=c.out -o coverage.html
	xdg-open coverage.html

TESTDIR ?= ./physics/deviceStructures/connection
TESTNAME ?= TestConnection_ErrorOnClosed

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

test-traceback:
	LD_LIBRARY_PATH=/usr/local/lib:$$LD_LIBRARY_PATH GOTRACEBACK=crash go test -v  ./...
