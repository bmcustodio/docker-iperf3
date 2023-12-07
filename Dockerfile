FROM debian:stable AS builder
ARG VERSION
RUN apt update
RUN apt install --yes build-essential curl
WORKDIR /iperf3
RUN curl -fsSLO https://downloads.es.net/pub/iperf/iperf-$VERSION.tar.gz{,.sha256}
RUN sha256sum iperf-$VERSION.tar.gz > iperf3.sha256
RUN diff iperf3.sha256 iperf-$VERSION.tar.gz.sha256
RUN tar zxvf iperf-$VERSION.tar.gz --strip-components=1
RUN ./configure --disable-shared --enable-static --enable-static-bin
RUN make
RUN make install

FROM gcr.io/distroless/static-debian12
COPY --from=builder /usr/local/bin/iperf3 /usr/local/bin/
EXPOSE 5201
ENTRYPOINT ["/usr/local/bin/iperf3"]
CMD ["-s"]