#!/bin/bash

# Создание обратного прокси
# shellcheck disable=SC2164
cd docker/proxy
docker-compose down && docker-compose up -d
cd ../../

docker-compose down && docker-compose build --no-cache