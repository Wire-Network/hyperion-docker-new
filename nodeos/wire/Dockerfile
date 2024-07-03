FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    jq \
    git \
    build-essential \
    cmake \
    tzdata \
    ca-certificates \
    libtinfo5 \
    libusb-1.0-0

# Update CA certificates
RUN update-ca-certificates

# Download necessary Debian packages
RUN wget http://launchpadlibrarian.net/361669149/libicu60_60.2-3ubuntu3_amd64.deb
RUN wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb
RUN wget --no-check-certificate -O /eosio.deb https://github.com/siliconswampio/wire-eosio/releases/download/v2.0.13/eosio_2.0.13-1_amd64.deb

# Install Debian packages
RUN dpkg -i libicu60_60.2-3ubuntu3_amd64.deb
RUN dpkg -i libssl1.1_1.1.1f-1ubuntu2.22_amd64.deb
RUN dpkg -i /eosio.deb || apt-get install -f -y

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#### OLD LEAP NODE DOCKERFILE BELOW ####

# RUN apt-get update
# RUN apt-get upgrade
# RUN apt-get autoremove

# RUN apt-get install -y wget

# WORKDIR /nodeos

# RUN wget -nv https://github.com/AntelopeIO/leap/releases/download/v4.0.0/leap_4.0.0-ubuntu22.04_amd64.deb
# RUN apt-get install -y ./leap_4.0.0-ubuntu22.04_amd64.deb
# RUN rm ./leap_4.0.0-ubuntu22.04_amd64.deb

# EXPOSE 8080
