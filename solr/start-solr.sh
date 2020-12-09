#!/bin/bash

WAIT_FILE="/opt/solr/server/solr/solr.xml.lock"

echo "waiting for $WAIT_FILE"
until [ -e "$WAIT_FILE" ]; do
  sleep 1
done
echo "$WAIT_FILE detected"

solr-foreground
