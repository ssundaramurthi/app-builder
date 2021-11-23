FROM alpine:3.14
ARG secret
EXPOSE 4246

RUN apk upgrade && apk add --no-cache git make musl-dev go bash

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /app-builder
ENV PATH /app/bin:$PATH

ENV SECRET $secret

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

COPY app/src/*.go ${GOPATH}/src/

WORKDIR ${GOPATH}/src
RUN go mod init app-builder

RUN go build ${GOPATH}/src
RUN cp ./app-builder ${GOPATH}/bin/
RUN rm -fr ${GOPATH}/src/

WORKDIR ${GOPATH}/bin

ENTRYPOINT ["/bin/bash", "-c", "./app-builder"]