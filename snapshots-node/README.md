# Snapshots node

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

## TO-DOs

[ ] Prune the node before uploading the snapshots
