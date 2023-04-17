#!/bin/bash

# Download and install V2Ray
curl -L -s https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o v2ray.zip
unzip v2ray.zip
chmod +x v2ray

# Define the path to the V2Ray configuration file
V2RAY_CONFIG_PATH="/path/to/config.json"

# Check if the V2Ray configuration file exists
if [ ! -f "$V2RAY_CONFIG_PATH" ]; then
    echo "Error: V2Ray configuration file not found in $V2RAY_CONFIG_PATH"
    exit 1
fi

# Run V2Ray with the specified configuration file
./v2ray -config "$V2RAY_CONFIG_PATH"

# Generate V2Ray configuration in protobuf format
DIR_CONFIG="/etc/v2ray"
DIR_TMP="$(mktemp -d)"

ID=98f3d58a-a53d-4662-9698-83e6ac172b47
AID=64
WSPATH=/
PORT=80

cat << EOF > "${DIR_TMP}/heroku.json"
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

mkdir -p "${DIR_CONFIG}"
./v2ctl config "${DIR_TMP}/heroku.json" > "${DIR_CONFIG}/config.pb"

# Run V2Ray with the generated configuration file
${DIR_RUNTIME}/v2ray -config="${DIR_CONFIG}/config.pb"
