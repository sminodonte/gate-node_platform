#!/bin/bash

# load configuration variables
source .env

# Install Zerotier and add to network
curl -s https://install.zerotier.com/ | sudo bash
sudo zerotier-cli join $VPN_NETWORK
sudo zerotier-cli status

# example for starting the docker container in localhost
# NOTE: you should set your env_file before running the container

# stop and delete gate-node_platform container if already exists
docker-compose down
sleep 2s

# delete all image of gate-node platform
docker rmi $GATENODE_IMAGE
docker rmi $MEDIANODE_IMAGE

# delete the docker virtualenv volume for data persistency if already exists
docker volume rm virtualenv

# create new the docker volume for data persistency
docker volume create virtualenv

# start a new container for the gate-node_platform
docker-compose up -d