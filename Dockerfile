FROM 710267309417.dkr.ecr.us-east-1.amazonaws.com/ecr-public/docker/library/alpine:3 AS alpine
RUN apk add -U --no-cache ca-certificates

FROM 710267309417.dkr.ecr.us-east-1.amazonaws.com/ecr-public/docker/library/golang:1.18-alpine AS build
RUN apk add -U --no-cache make
WORKDIR /workspace
COPY . .
RUN make install

FROM 710267309417.dkr.ecr.us-east-1.amazonaws.com/ecr-public/docker/library/alpine:3
EXPOSE 3000
ENV GODEBUG netdns=go
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /go/bin/drone-amazon-ssm /go/bin/

ENTRYPOINT ["/go/bin/drone-amazon-ssm"]
