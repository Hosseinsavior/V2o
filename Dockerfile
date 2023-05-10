FROM alpine:latest

EXPOSE 80

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x entrypoint.sh

CMD ["bash entrypoint.sh"]
