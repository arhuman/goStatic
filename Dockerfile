# stage 0
FROM golang:latest as builder
WORKDIR /go/src/github.com/PierreZ/goStatic
COPY . .

RUN GOARCH=amd64 GOOS=linux go build -tags netgo -installsuffix netgo -ldflags "-linkmode external -extldflags -static -s"

# stage 2
FROM eraclitux/go-mini-container as packer
WORKDIR /go/src/github.com/eraclitux/rim
COPY --from=builder /go/src/github.com/PierreZ/goStatic/goStatic .
RUN strip goStatic
RUN upx goStatic

# stage 2
FROM centurylink/ca-certs
WORKDIR /
COPY --from=packer /go/src/github.com/eraclitux/rim/goStatic /
ENTRYPOINT ["/goStatic"]
