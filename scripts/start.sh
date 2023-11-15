#!/bin/bash

echo "Creating containers... "
docker-compose -f docker-compose-cli.yaml up -d


echo "Containers started" 
docker ps

echo
#Creating channel and join Dyno
docker exec -it cli ./scripts/channel/createChannel.sh



