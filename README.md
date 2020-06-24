# GATE-NODE_PLATFORM #

This folder containes a GATE-NODE platform composition, using Docker Compose as tool for orchestrating all services.

## Steps to deployment gate-node_platform
### FIRST TIME

- On linux edit the daemon.json file and follow these steps:
```bash
# go to /etc/docker ant create the file deamon.json and edit:
{
  "insecure-registries" : ["156.148.132.82:5000","192.168.193.139:5000"]
}
```
- Reboot the machine from shell:
```bash
reboot
```
- For other platforms follow these steps https://docs.docker.com/registry/insecure

###### Set variables environment

Before starting the platform you have to init the environment variables both for single container execution and for orchestration purposes.
This repo provides you two default environment files called:

* _env_file.default_ containing the variables for docker images configuration

* _.env.default_ containing the variables for docker compose configuration


You have just to rename and set the proper variables' values:
```bash
# copy and rename the environment files
cp env_file.default env_file
cp .env.default .env
# set variables values
nano env_file
nano .env
```
###### Basic configuration

In the .env file change the variables:

- GATENODE_IMAGE
- MEDIANODE_IMAGE

put gate-node/media-node or gate-node_arm/media-node_arm depending on whether you have an arm architecture or not.

In the .env_file file change the variable:

- NODE_NAME

###### Dependencies

In order to execute the GATE-NODE platform in a single machine mode, it is necessary to install the following tools in the machine:

* __Docker Engine__ (>= 19.03.1) to execute the container services

* __Docker Compose__ (>= 1.24.1) to orchestrate the container execution


###### Service setup

To run FIRST time the composed/orchestrated services you have just to run the following command:
```bash
/bin/bash init.sh
```

Now the GATE-NODE and whole plugins are runnning.

To stop and remove all service containers you have to run the following command:
```bash
/bin/bash stop.sh
```

When you want restart the services you have to run the following command: 
```bash
/bin/bash start.sh
```

### FOR EVERY OTHER TIME
-   On shell execute
```bash
/bin/sh start.sh
```

__IMPORTANT: Every time the init.sh is launched the system is reset and a new node will be created, for this reason it is important not to use it more than once. Then always use start.sh to restart the system.__

### UNINSTALL GATE-NODE 

-   On shell execute
```bash
/bin/sh uninstall.sh
```

## Send message from third party software to gate-node

Once that gate-node is turn on, another application could send message by socket.io with this kind configuration:

 * hostname: localhost
 * port: 3002
 * channel/topic/room: "gatenode"  

###### Format of the JSON message:
```
{ "destination": [node1,node2,node3,...], payload:{...}}
```

__IMPORTANT:__

__- these message is a JSON format file and not a STRING;__

__- in the destination "node" represent the names of the nodes to which to send json messages.__

