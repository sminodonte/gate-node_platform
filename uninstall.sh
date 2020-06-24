#!/bin/bash

# load configuration variables
source .env

# stop and delete gate-node_platform container if already exists
docker-compose down
sleep 2s

# delete all image of gate-node platform
docker rmi $GATENODE_IMAGE
docker rmi $MEDIANODE_IMAGE

# delete the docker virtualenv volume for data persistency if already exists
docker volume rm virtualenv

#leave VPN zerotier network
sudo zerotier-cli leave $VPN_NETWORK