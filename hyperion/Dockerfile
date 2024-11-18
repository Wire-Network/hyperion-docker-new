FROM node:20

# Install PM2 globally
RUN npm install pm2 -g

# Install necessary tools for building node-abieos
RUN apt-get update && apt-get install -y cmake g++

# Clone the main repository recursively to include submodules
RUN git clone --recursive https://github.com/Wire-Network/hyperion-history-api.git

# Build the node-abieos submodule
WORKDIR /hyperion-history-api/addons/node-abieos
RUN git submodule update --init --recursive
RUN npm install
RUN npm run build:linux:ci

# Switch back to the main hyperion-history-api directory
WORKDIR /hyperion-history-api
RUN npm install

## CUSTOM hyperion-history-api at sister directory level
# FROM node:20

# # Install pm2 globally
# RUN npm install pm2 -g

# # Set the working directory inside the container
# WORKDIR /hyperion-history-api

# # COPY the local hyperion-history-api directory into the container
# COPY ./hyperion-history-api/ /hyperion-history-api/

# # Install dependencies
# RUN npm install
