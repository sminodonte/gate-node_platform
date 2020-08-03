#!/bin/bash

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

# stop and delete gate-node_platform container if already exists
docker-compose down

# start a new container for the gate-node_platform
docker-compose up -d
