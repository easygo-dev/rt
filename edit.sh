#!/bin/bash

# File paths
CONFIG_FILE1=~/infernet-container-starter/deploy/config.json
CONFIG_FILE2=~/infernet-container-starter/projects/hello-world/container/config.json
DEPLOY_SCRIPT=~/infernet-container-starter/projects/hello-world/contracts/script/Deploy.s.sol
MAKEFILE=~/infernet-container-starter/projects/hello-world/contracts/Makefile
DOCKER_COMPOSE=~/infernet-container-starter/deploy/docker-compose.yaml

# Ask the user for parameters
read -p "Enter new rpc_url: " rpc_url
read -p "Enter new batch_size: " batch_size
read -p "Enter new private_key (without 0x prefix): " private_key
read -p "Enter new registry_address: " registry_address
read -p "Enter new infernet-node version (e.g., 1.2.0): " node_version

# Add "0x" prefix to private_key
private_key="0x$private_key"

# Function to edit files
edit_file () {
  local file=$1
  echo "Editing file: $file"

  # Replace rpc_url
  sed -i "s|\"rpc_url\": \".*\"|\"rpc_url\": \"$rpc_url\"|g" "$file"

  # Replace batch_size
  sed -i "s|\"batch_size\": [0-9]*|\"batch_size\": $batch_size|g" "$file"

  # Replace private_key
  sed -i "s|\"private_key\": \".*\"|\"private_key\": \"$private_key\"|g" "$file"

  # Replace registry_address
  sed -i "s|\"registry_address\": \".*\"|\"registry_address\": \"$registry_address\"|g" "$file"

  # Add "starting_sub_id": 100000 to the "snapshot_sync" block
  sed -i '/"batch_size": '"$batch_size"'/a \        "starting_sub_id": 100000' "$file"

  echo "Changes applied to $file."
}

# Apply changes to config.json files
edit_file "$CONFIG_FILE1"
edit_file "$CONFIG_FILE2"

# 1. Edit Deploy.s.sol
echo "Editing Deploy.s.sol: $DEPLOY_SCRIPT"
sed -i "s|address registry = .*;|address registry = $registry_address;|g" "$DEPLOY_SCRIPT"
echo "Changes applied to Deploy.s.sol."

# 2. Edit Makefile
echo "Editing Makefile: $MAKEFILE"
sed -i "s|sender := .*|sender := $private_key|g" "$MAKEFILE"
sed -i "s|RPC_URL := .*|RPC_URL := $rpc_url|g" "$MAKEFILE"
echo "Changes applied to Makefile."

# 3. Edit docker-compose.yaml
echo "Editing docker-compose.yaml: $DOCKER_COMPOSE"
sed -i "s|image: ritualnetwork/infernet-node:.*|image: ritualnetwork/infernet-node:$node_version|g" "$DOCKER_COMPOSE"
echo "Changes applied to docker-compose.yaml."

echo "All changes have been successfully applied to all files."
