FROM debian:buster

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and install V2Ray
RUN curl -L -s https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o v2ray.zip && \
    unzip v2ray.zip && \
    chmod +x v2ctl v2ray

# Define the path to the V2Ray configuration file
ENV V2RAY_CONFIG_PATH="/app/config.json"

# Copy configuration file
COPY config.json $V2RAY_CONFIG_PATH

# Expose port 80
EXPOSE 80

# Generate V2Ray configuration in protobuf format
ENV DIR_CONFIG="/etc/v2ray"
ENV DIR_TMP="$(mktemp -d)"

ENV ID=98f3d58a-a53d-4662-9698-83e6ac172b47
ENV AID=64
ENV WSPATH=/

RUN cat << EOF > "${DIR_TMP}/heroku.json" && \
    {
        "inbounds": [{
            "port": ${PORT},
            "protocol": "vmess",
            "settings": {
                "clients": [{
                    "id": "${ID}",
                    "alterId": ${AID}
                }]
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "${WSPATH}"
                }
            }
        }],
        "outbounds": [{
            "protocol": "freedom"
        }]
    }
EOF

RUN mkdir -p "${DIR_CONFIG}" && \
    ./v2ray config "${DIR_TMP}/heroku.json" > "${DIR_CONFIG}/config.pb"

# Run V2Ray with the generated configuration file
CMD ["./entrypoint.sh","-config=${DIR_CONFIG}/config.pb"]
