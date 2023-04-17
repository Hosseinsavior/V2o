FROM alpine:latest

# Install dependencies
RUN apk update \
    && apk add --no-cache curl unzip bash

# Download and install V2Ray
RUN curl -L -s https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o v2ray.zip && \
    unzip v2ray.zip && \
    chmod +x v2ctl v2ray

# Set the working directory to /etc/v2ray
WORKDIR /etc/v2ray/

# Copy the configuration file 
COPY config.json .

# Copy the startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the ENTRYPOINT to start the V2Ray service
ENTRYPOINT ["/entrypoint.sh"]
