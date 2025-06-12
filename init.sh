#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- CLIENT SETUP (client/) ---

# Fetch latest updates for the 'client/' submodule.
git submodule update --remote client/ || { echo "Failed to update client submodule."; exit 1; }

# Navigate into the client directory.
cd client/ || { echo "Failed to navigate to client/ directory. Does it exist?"; exit 1; }

# Install pnpm dependencies.
pnpm install || { echo "Failed to install pnpm dependencies in client/."; exit 1; }

# Run the client development server in the background.
nohup pnpm dev &> ../client_dev_log.txt &
CLIENT_PID=$!

# Navigate back to the main repository root.
cd .. || { echo "Failed to navigate back to main repository root."; exit 1; }


# --- SERVER SETUP (server/) ---

# Navigate into the server directory.
cd server/ || { echo "Failed to navigate to server/ directory. Does it exist?"; exit 1; }

# Build and start Docker services.
# By default, runs in foreground. Use '-d' for detached mode.
docker compose down && docker compose up --build || { echo "Failed to start Docker Compose services in server/."; exit 1; }
# docker compose up -d --build || { echo "Failed to start Docker Compose services in server/."; exit 1; }
