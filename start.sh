#! /usr/bin/env bash

echo "$CRON_SCHEDULE $MBSYNC_CMD" > /tmp/mbsync_crontab

supercronic -passthrough-logs /tmp/mbsync_crontab
