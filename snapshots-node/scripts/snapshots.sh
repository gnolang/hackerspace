#!/usr/bin/env sh

DAEMON_HOME="/gnoroot/gnoland-data"

HEIGHT=$(curl -s gnoland:26657/status | jq -r '.result.sync_info.latest_block_height')
echo "[INFO] Snapshotting at height: ${HEIGHT}"

echo "[INFO] Stopping gnoland..."
docker compose stop gnoland

FILE="gnoland-${HEIGHT}-${CHAIN_ID}.tar.lz4"

tar cvf - -C ${DAEMON_HOME} wal db | lz4 > $FILE

mcli cp --attr x-amz-acl=public-read --tags="type=snapshot" ${FILE} "s3/${MC_BUCKET}/${CHAIN_ID}/${FILE}"; echo

rm -vf ${FILE}

echo "[INFO] Starting gnoland ..."
docker compose start gnoland
