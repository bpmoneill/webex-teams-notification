FROM golang:latest as builder

ENV WEBEX_DIR="github.com/build/webex-teams-notification"
WORKDIR $GOPATH/src/$WEBEX_DIR

COPY . .

RUN mkdir -p /cmd
RUN CGO_ENABLED=0 GOOS=linux go build -o /cmd/check check/check.go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /cmd/out out/out.go
RUN CGO_ENABLED=0 GOOS=linux go build -o /cmd/in in/in.go

FROM alpine:3.7
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
RUN update-ca-certificates
COPY --from=builder /cmd/ /opt/resource/
RUN chmod +x /opt/resource/*

