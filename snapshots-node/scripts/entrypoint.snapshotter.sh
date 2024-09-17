#!/usr/bin/env sh

apk add --no-cache curl jq lz4 minio-client

alias mc=mcli

export DAEMON_HOME="/gnoroot/gnoland-data"

[ -z "$MC_ENDPOINT" ]   && echo "MC_ENDPOINT is not set, skip snapshot"   && exit 1
[ -z "$MC_ACCESS_KEY" ] && echo "MC_ACCESS_KEY is not set, skip snapshot" && exit 1
[ -z "$MC_SECRET_KEY" ] && echo "MC_SECRET_KEY is not set, skip snapshot" && exit 1

mc alias set s3 ${MC_ENDPOINT} ${MC_ACCESS_KEY} ${MC_SECRET_KEY}

# exec snapshots script every 4 hours
echo "0 */4 * * * sh /scripts/snapshots.sh" > /etc/crontabs/root
crontab /etc/crontabs/root

exec crond -f
