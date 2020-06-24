#!/bin/bash

# Install Zerotier and add to network
# curl -s https://install.zerotier.com/ | sudo bash
# sudo zerotier-cli join 83048a06328ea5ef
# sudo zerotier-cli status

# example for starting the docker container in localhost
# NOTE: you should set your env_file before running the container

# stop and delete gate-node_platform container if already exists
docker-compose down

# start a new container for the gate-node_platform
docker-compose up -d
