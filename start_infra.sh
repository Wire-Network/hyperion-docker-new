# @echo off
cd infra
./configure.sh 
docker compose --profile tools up -d
