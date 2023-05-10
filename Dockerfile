FROM ubuntu:latest


RUN apt-get update && \
    apt-get install -y curl unzip busybox


ENV DIR_CONFIG="/etc/v2ray"
ENV DIR_RUNTIME="/usr/bin"
ENV DIR_TMP="/tmp"

ENV ID="98f3d58a-a53d-4662-9698-83e6ac172b47"
ENV AID="64"
ENV WSPATH="/"
ENV PORT="80"


COPY entrypoint.sh /entrypoint.sh


RUN chmod +x /entrypoint.sh


CMD ["/entrypoint.sh"]
