FROM alpine:3.14
ARG secret
EXPOSE 80

RUN apk upgrade && apk add --no-cache git make musl-dev go bash

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

ENV SECRET $secret

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

COPY app/src/*.go /go/src/

WORKDIR $GOPATH

ENTRYPOINT ["/bin/bash", "-c", "go run /go/src/main.go /go/src/handler.go"]