FROM resin/raspberrypi3-golang:1.10 as builder

ENV ETCD_BRANCH release-3.3
ENV GOPATH=/go
ENV GOOS=linux
ENV GOARCH=arm
ENV GOARM=7

RUN [ "cross-build-start" ]

WORKDIR /go/src/github.com/coreos

RUN git clone --branch ${ETCD_BRANCH} https://github.com/coreos/etcd.git

RUN cd etcd && ./build

RUN cd etcd/bin && ls

RUN [ "cross-build-end" ]

FROM resin/raspberrypi3-alpine:3.8

ENV ETCD_UNSUPPORTED_ARCH=arm

RUN [ "cross-build-start" ]

COPY --from=builder /go/src/github.com/coreos/etcd/bin/etcd /usr/local/bin
COPY --from=builder /go/src/github.com/coreos/etcd/bin/etcdctl /usr/local/bin

RUN etcd --version

RUN [ "cross-build-end" ]

CMD ["etcd"]
