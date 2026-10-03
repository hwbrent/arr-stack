# !/bin/bash

docker compose down

git fetch

git pull

docker compose up -d
