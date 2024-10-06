#!/bin/bash

# File paths
CONFIG_FILE1=~/infernet-container-starter/deploy/config.json
CONFIG_FILE2=~/infernet-container-starter/projects/hello-world/container/config.json
MAKEFILE=~/infernet-container-starter/projects/hello-world/contracts/Makefile

# Ask the user for parameters
read -p "Enter new rpc_url: " rpc_url
read -p "Enter new batch_size: " batch_size

# Function to edit config.json files (rpc_url and batch_size)
edit_config_files () {
  local file=$1
  echo "Editing file: $file"

  # Replace rpc_url
  sed -i "s|\"rpc_url\": \".*\"|\"rpc_url\": \"$rpc_url\"|g" "$file"

  # Replace batch_size and ensure proper formatting (remove trailing comma if exists)
  sed -i "s|\"batch_size\": [0-9]*,|\"batch_size\": $batch_size|g" "$file"
  sed -i "s|\"batch_size\": [0-9]*|\"batch_size\": $batch_size|g" "$file"

  echo "Changes applied to $file."
}

# Function to edit Makefile (only rpc_url)
edit_makefile () {
  local file=$1
  echo "Editing Makefile: $file"

  # Replace rpc_url
  sed -i "s|RPC_URL := .*|RPC_URL := $rpc_url|g" "$file"

  echo "Changes applied to Makefile."
}

# Apply changes to config.json files
edit_config_files "$CONFIG_FILE1"
edit_config_files "$CONFIG_FILE2"

# Apply changes to Makefile
edit_makefile "$MAKEFILE"

echo "All changes have been successfully applied."

