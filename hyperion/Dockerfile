FROM node:20
RUN npm install pm2 -g
RUN git clone https://github.com/eosrio/hyperion-history-api.git
WORKDIR /hyperion-history-api
RUN git checkout main
RUN npm install
