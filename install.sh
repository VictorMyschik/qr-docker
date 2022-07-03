#!/bin/bash

# Создание обратного прокси
# shellcheck disable=SC2164
cd docker/proxy
docker-compose down && docker-compose up -d
cd ../../

docker-compose down && docker-compose build --no-cache

docker-compose up -d

git clone git@github.com:quintegro/CampingWorld-RVRentals-Web.git www
docker exec -it php bash