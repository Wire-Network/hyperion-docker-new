# FOR LEAP v3.1.4

FROM ubuntu:22.04

# Update and install required packages
RUN apt-get update
RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get -y install zip unzip libncurses5 wget git build-essential cmake curl libcurl4-openssl-dev libgmp-dev libssl-dev libusb-1.0.0-dev libzstd-dev time pkg-config zlib1g-dev libtinfo-dev bzip2 libbz2-dev python3 file

# # Download necessary Debian packages
RUN wget -O /wire.deb https://files.siliconswamp.io/leap-3.1.5-ubuntu22.04-x86_64.deb

# Install Debian packages
RUN apt-get update
RUN apt-get install -y ./wire.deb