FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade
RUN apt-get autoremove

RUN apt-get install -y wget

WORKDIR /nodeos

RUN wget -nv https://github.com/AntelopeIO/leap/releases/download/v4.0.0/leap_4.0.0-ubuntu22.04_amd64.deb
RUN apt-get install -y ./leap_4.0.0-ubuntu22.04_amd64.deb
RUN rm ./leap_4.0.0-ubuntu22.04_amd64.deb

EXPOSE 8080