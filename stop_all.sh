# @echo off

cd hyperion
docker compose down
cd ../infra
docker compose down
cd ../nodeop 
docker compose down