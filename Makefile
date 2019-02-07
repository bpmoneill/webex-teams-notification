COMPONENT_NAME:=webex-teams-notification
COMPONENT_VERSION=$(if $(subst master,,$(BRANCH)),$(VERSION)-$(BRANCH).$(GITHUB_SHA),$(VERSION))

.PHONY: all build docker publish test clean

all: build

build:
	@go build ${LDFLAGS} -o check/check check/check.go
	@go build ${LDFLAGS} -o in/in in/in.go
	@go build ${LDFLAGS} -o out/out out/out.go

docker: build
	$(info Builder docker image for $(COMPONENT_NAME))
	@docker build . -t $(COMPONENT_NAME)

docker_install:
	$(info Installing $(COMPONENT_NAME))
	@CGO_ENABLED=0 go build -i ${LDFLAGS} -o check/check check/check.go
	@CGO_ENABLED=0 go build -i ${LDFLAGS} -o in/in in/in.go
	@CGO_ENABLED=0 go build -i ${LDFLAGS} -o out/out out/out.go

clean:
	$(info Cleaning $(COMPONENT_NAME))
	@rm -f ${COMPONENT_NAME}
