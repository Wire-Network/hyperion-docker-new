# Use a specific version of node that is compatible with your project
FROM node:20

# Install pm2 globally
RUN npm install pm2 -g

# Set the working directory inside the container
WORKDIR /hyperion-history-api

# COPY the local hyperion-history-api directory into the container
COPY ./hyperion-history-api/ /hyperion-history-api/

# Install dependencies
RUN npm install


# FROM node:20
# RUN npm install pm2 -g
# # RUN git clone https://github.com/eosrio/hyperion-history-api.git
# WORKDIR /hyperion-history-api
# RUN git checkout main
# RUN npm install
