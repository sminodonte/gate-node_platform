#!/bin/bash

# load configuration variables
source .env

sudo rm -rf do_not_touch_file

if [ "$(uname)" == "Darwin" ]; then
    # SHOW ALL IP ADDRESS OF ALL INTERFACE
    external_ip=$(curl ipecho.net/plain ; echo)
    internal_ip=$(ipconfig getifaddr en0)
    vpn_ip=$(ifconfig  | awk '$1 == "inet" {print $2}' | awk '/^192.168.193/')   
    export EXTERNAL_IP=$external_ip INTERNAL_IP=$internal_ip VPN_IP=$vpn_ip
    ALLIP='$EXTERNAL_IP:$INTERNAL_IP:$VPN_IP'
    envsubst "$ALLIP" < "env_file" > "do_not_touch_file"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # SHOW ALL IP ADDRESS OF ALL INTERFACE
    external_ip=$(curl ipecho.net/plain ; echo) wlan0
    internal_ip=$(ifconfig wlan0 | grep -i mask | awk '{print $2}'| cut -f2 -d:)
    vpn_ip=$(ip -o -4 addr show | awk '{print $2 " " $4}' | awk '/^ztqu/ { print }' | awk '{print $2}' | awk -F'[/ ]+' '{ print $1 }')
fi

# SEARCH ID CONTAINER FROM NAME OF IMAGE
# id=$(docker ps --no-trunc --quiet --filter="ancestor=192.168.193.139:5000/gate-node")
# [ -z "$id" ] && echo "no id" && exit 1

# DELETE NODE FROM NETWORK
docker exec -i gate-node_platform_gate-node_1 /bin/sh unregister.sh

# Install Zerotier and add to network
curl -s https://install.zerotier.com/ | sudo bash
sudo zerotier-cli join $VPN_NETWORK
sudo zerotier-cli status
sleep 2s
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