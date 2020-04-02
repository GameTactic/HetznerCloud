#!/usr/bin/env bash
set -e

# Extract "host" argument from the input into HOST shell variable
eval "$(jq -r '@sh "HOST=\(.host)"')"

# Fetch Cluster Tokens
MANAGER=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token manager -q)
WORKER=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token worker -q)

# Produce a JSON object containing the tokens
jq -n --arg manager "$MANAGER" --arg worker "$WORKER" '{"manager":$manager,"worker":$worker}'
