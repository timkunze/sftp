#!/bin/bash
# Setup cron service
crontab /etc/cron.d/upload-files-cron
service cron start
# Prepare aws cli
mkdir /root/.aws
envsubst < /config.template > /root/.aws/config
envsubst < /credentials.template > /root/.aws/credentials
