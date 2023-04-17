# Use a base image with the required dependencies
FROM debian:buster-slim

# Install curl and unzip
RUN apt-get update && apt-get -y install curl unzip

# Download and install V2Ray
WORKDIR /usr/local/bin
RUN curl -L -s https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o v2ray.zip \
    && unzip v2ray-linux-64.zip \
    && chmod +x v2ray \
    && rm v2ray-linux-64.zip

# Copy the entrypoint script to the container
COPY entrypoint.sh /

# Make the script executable
RUN chmod +x /entrypoint.sh

# Define the path to the V2Ray configuration file
ENV V2RAY_CONFIG_PATH "/etc/v2ray/config.json"

# Set the working directory to /etc/v2ray
WORKDIR /etc/v2ray

# Copy the sample configuration file to the container
COPY config.json .

# Expose the ports used by V2Ray
EXPOSE 80

# Start V2Ray using the configuration file provided by the user
ENTRYPOINT ["/entrypoint.sh"]
