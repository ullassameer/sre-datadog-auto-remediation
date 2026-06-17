#!/bin/bash

set -e

mkdir -p /tmp/sre

df -h \
> /tmp/sre/disk.txt

du -xh /var/log \
--max-depth=2 \
2>/dev/null \
> /tmp/sre/logs.txt

find /var/log \
-type f \
-mtime +60 \
> /tmp/sre/delete_candidates.txt

tar -czf \
/tmp/sre/diagnostics.tar.gz \
/tmp/sre

echo "Diagnostics completed"

aws s3 cp \
/tmp/sre/diagnostics.tar.gz \
s3://$1/diagnostics/

echo "Upload completed"