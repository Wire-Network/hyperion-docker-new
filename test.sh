#!/usr/bin/env bash
# Test connection to elasticsearch using custom CA
curl --cacert ca.crt -u elastic:changeme123 https://localhost:9200
