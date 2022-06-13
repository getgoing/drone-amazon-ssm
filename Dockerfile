FROM alpine:3.6 as alpine
RUN apk add -U --no-cache ca-certificates

FROM golang:1.18.2-alpine as build
RUN apk add -U --no-cache make
WORKDIR /workspace
COPY . .
RUN make install

FROM alpine:3.6
EXPOSE 3000
ENV GODEBUG netdns=go
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/drone-amazon-ssm /go/bin/

ENTRYPOINT ["/go/bin/drone-amazon-ssm"]
