#!/bin/bash

set -e

BUCKET=$1

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DATE=$(date +%Y-%m-%d)
HOST=$(hostname)

mkdir -p /tmp/sre

echo "Collecting disk usage..."

df -h \
> /tmp/sre/disk.txt

echo "Collecting log sizes..."

du -xh /var/log \
--max-depth=2 \
2>/dev/null \
> /tmp/sre/logs.txt

echo "Finding old logs..."

find /var/log \
-type f \
-mtime +60 \
> /tmp/sre/delete_candidates.txt

echo "Creating archive..."

tar -czf \
/tmp/sre/diagnostics.tar.gz \
/tmp/sre

echo "Diagnostics completed"

echo "Uploading to:"

echo "s3://$BUCKET/diagnostics/$DATE/$HOST/diagnostics-${TIMESTAMP}.tar.gz"

aws s3 cp \
/tmp/sre/diagnostics.tar.gz \
"s3://$BUCKET/diagnostics/$DATE/$HOST/diagnostics-${TIMESTAMP}.tar.gz"

echo "Upload completed"