FROM alpine:latest

# Install dependencies
RUN apk update && \
    apk add curl unzip bash

# Download and install V2Ray
RUN curl -L -s https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o v2ray.zip && \
    unzip v2ray.zip && \
    chmod +x v2ctl v2ray

# Copy the configuration file and startup script
COPY config.json /etc/v2ray/config.json
COPY start-v2ray.sh /start-v2ray.sh
RUN chmod +x /start-v2ray.sh

# Set the ENTRYPOINT to start the V2Ray service
ENTRYPOINT ["/entrypoint.sh"]
