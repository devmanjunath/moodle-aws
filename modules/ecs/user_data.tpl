#!/bin/bash

#Adding cluster name in ecs config
sudo echo ECS_CLUSTER=Test-Drive-Cluster >> /etc/ecs/ecs.config
sudo echo ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"] >> /etc/ecs/ecs.config
cat /etc/ecs/ecs.config | grep "ECS_CLUSTER"