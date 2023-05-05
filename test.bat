@echo off
REM Test connection to elasticsearch using custom CA
curl --cacert ca.crt --ssl-revoke-best-effort -u elastic:changeme123 https://localhost:9200
