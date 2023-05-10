FROM alpine:latest

EXPOSE 80

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x root/entrypoint.sh

CMD ["bash entrypoint.sh"]
