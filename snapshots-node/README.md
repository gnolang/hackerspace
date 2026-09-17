# Snapshots node

> [!WARNING]
> `docker-compose.yml` still pins `ghcr.io/gnolang/gno/gnoland:chain-test4.3` with
> `CHAIN_ID: test4`. test4 was retired in 2024. Repoint the image tag and chain id at
> the network you actually want to snapshot (see
> [Gno networks](https://docs.gno.land/resources/gnoland-networks)) before running this.

## How it's works

1. Setup the environment variables and setup the variables for the [minio-client](https://min.io) with your S3 credentials

``` sh
cp env.example env
```

2. Start the node

By default, a snapshots will occur every 4 hours, and will upload it to S3

``` sh
docker compose up -d
```

## How to force a snapshot now

``` sh
docker compose exec snapshotter sh /scripts/snapshots.sh
```

## TO-DOs

[ ] Prune the node before uploading the snapshots
