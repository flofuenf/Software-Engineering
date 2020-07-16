# For local build run this from git.raceresult.com folder:
# docker build -f Dockerfile -t pizza .

FROM flofuenf/flutter_build:latest as flutterBuilder

# Copy files to container and build
RUN mkdir /usr/local/communeism
COPY . /usr/local/communeism
WORKDIR /usr/local/communeism
RUN ls -la
RUN /usr/local/flutter/bin/flutter build web --release

###############################################

FROM golang:1.14.0-alpine as builder

#ENV GOPROXY=http://192.168.10.58:3000

# Install SSL ca certificates and create appuser
RUN apk update && \
    apk add git && \
    apk add ca-certificates && \
    adduser -D -g '' appuser

# Create workaround dir for logfiles in builder and touch empty file to copy
RUN mkdir -p /app/data/files
RUN touch /app/data/files/workaround
RUN chown -R appuser: /app

# source code
COPY . $GOPATH/src/gitlab.com/flofuenf/communeism
WORKDIR $GOPATH/src/gitlab.com/flofuenf/communeism

#RUN git clone https://git.rrdc.de/shared/scripts.git && \
#    chmod +x scripts/* && \
#    mv scripts/* /usr/local/bin

#RUN git config --global url."git@git.rrdc.de:".insteadOf "https://git.rrdc.de/"
#RUN go env -w GOPRIVATE=git.rrdc.de

# build
RUN GO111MODULE=on go mod download
RUN export VERSION=$(git-semver-describe --tags) && \
    echo version: $VERSION && \
    GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/communeism .

# Build a minimal and secured container
FROM debian:stretch-slim
RUN mkdir /data
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /app/data/files/workaround /app/data/files/workaround
COPY --from=builder /go/bin/communeism /app/
COPY --from=flutterBuilder /usr/local/communeism/build/web /app/static
USER appuser
WORKDIR /app
ENTRYPOINT ["/app/communeism"]
