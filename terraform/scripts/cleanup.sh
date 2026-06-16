#!/bin/bash

set -e

BUCKET="$1"

echo "=== Step 1 Archive ==="

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

tar -czf \
/tmp/fake-app-$TIMESTAMP.tar.gz \
/var/log/fake-app

echo "=== Step 2 Upload ==="

aws s3 cp \
/tmp/fake-app-$TIMESTAMP.tar.gz \
s3://$BUCKET/archive/

echo "=== Step 3 Verify Upload ==="

aws s3 ls \
s3://$BUCKET/archive/

echo "=== Step 4 Cleanup ==="

find \
/var/log/fake-app \
-type f \
-delete

echo "=== Step 5 Verify ==="

du -sh \
/var/log/fake-app

df -h /