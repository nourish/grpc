.PHONY: \
	all \
	deps \
	updatedeps \
	testdeps \
	updatetestdeps \
	build \
	proto \
	test \
	testrace \
	clean \

all: test testrace

deps:
	go get -d -v github.com/nourish/grpc/...

updatedeps:
	go get -d -v -u -f github.com/nourish/grpc/...

testdeps:
	go get -d -v -t github.com/nourish/grpc/...

updatetestdeps:
	go get -d -v -t -u -f github.com/nourish/grpc/...

build: deps
	go build github.com/nourish/grpc/...

proto:
	@ if ! which protoc > /dev/null; then \
		echo "error: protoc not installed" >&2; \
		exit 1; \
	fi
	go get -v github.com/nourish/protobuf/protoc-gen-go
	for file in $$(git ls-files '*.proto'); do \
		protoc -I $$(dirname $$file) --go_out=plugins=grpc:$$(dirname $$file) $$file; \
	done

test: testdeps
	go test -v -cpu 1,4 github.com/nourish/grpc/...

testrace: testdeps
	go test -v -race -cpu 1,4 github.com/nourish/grpc/...

clean:
	go clean github.com/nourish/grpc/...

coverage: testdeps
	./coverage.sh --coveralls
