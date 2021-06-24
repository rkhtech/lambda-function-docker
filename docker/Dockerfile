FROM alpine:latest

RUN apk add curl jq bash
ADD startup.sh /

ENTRYPOINT /startup.sh

