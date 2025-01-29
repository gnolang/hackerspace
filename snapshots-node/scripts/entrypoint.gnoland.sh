#!/usr/bin/env sh

LOG_LEVEL=${LOG_LEVEL:-"info"}

MONIKER=${MONIKER:-"gnode"}
P2P_LADDR=${P2P_LADDR:-"tcp://0.0.0.0:26656"}
RPC_LADDR=${RPC_LADDR:-"tcp://0.0.0.0:26657"}

CHAIN_ID=${CHAIN_ID:-"dev"}

gnoland config init

gnoland config set rpc.laddr     "${RPC_LADDR}"
gnoland config set p2p.laddr     "${P2P_LADDR}"

exec gnoland start --lazy --genesis="./gnoland-data/genesis.json" --log-level=${LOG_LEVEL}
