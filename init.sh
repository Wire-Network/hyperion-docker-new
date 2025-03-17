#!/usr/bin/env bash

# Determine the directory where this script resides (i.e. the project root)
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Project root: $PROJECT_ROOT"

# Function to create a symlink for .env in a target directory
create_symlink() {
  local target_dir="$1"
  local symlink_path="$target_dir/.env"
  if [ -d "$target_dir" ]; then
    if [ ! -e "$symlink_path" ]; then
      echo "Creating symlink for .env in $target_dir"
      ln -s "$PROJECT_ROOT/.env" "$symlink_path"
    else
      echo "Symlink for .env already exists in $target_dir"
    fi
  else
    echo "Directory $target_dir does not exist; skipping symlink creation."
  fi
}

# Create symlink in the infra and hyperion directories if they exist
create_symlink "$PROJECT_ROOT/infra"
create_symlink "$PROJECT_ROOT/hyperion"

# Check if the 'hyperion' network already exists; if not, create it
if docker network ls --format '{{.Name}}' | grep -q '^hyperion$'; then
  echo "Docker network 'hyperion' already exists."
else
  echo "Creating docker network 'hyperion'..."
  docker network create hyperion
fi