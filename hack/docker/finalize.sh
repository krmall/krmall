#!/bin/sh
set -x
set -e

# Create user for krmall
addgroup -S krmall
adduser -G krmall -H -D -g 'krmall User' krmall -h /data/krmall -s /bin/bash && usermod -p '*' krmall && passwd -u krmall
echo "export krmall_CUSTOM=${krmall_CUSTOM}" >> /etc/profile

# Final cleaning
rm /app/krmall/docker/finalize.sh
rm /app/krmall/docker/nsswitch.conf
