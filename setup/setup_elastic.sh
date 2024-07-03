#!/bin/bash

docker exec -it elasticsearch /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -a -s -b | tee elastic.password
