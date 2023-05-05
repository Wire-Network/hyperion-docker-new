@echo off
REM Tail the logs of the nodeos container
docker logs leap-node --follow
