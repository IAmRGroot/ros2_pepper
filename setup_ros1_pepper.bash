#!/bin/bash

export PYTHONHOME="/home/nao/.ros-root/Python-2.7.13"
export PATH="${PYTHONHOME}/bin:${PATH}"
export LD_LIBRARY_PATH="/home/nao/.ros-root/ros1_dependencies/lib:${PYTHONHOME}/lib:${LD_LIBRARY_PATH}"

export ROS_INTERFACE=eth0
export LOCAL_IP=`ifconfig $ROS_INTERFACE | grep "inet " | cut -d ' ' -f 10`
export ROS_MASTER_IP=169.254.114.121
export ROS_MASTER_URI=http://$ROS_MASTER_IP:11311
export ROS_HOSTNAME=$LOCAL_IP
export ROS_IP=$LOCAL_IP

export NAMESPACE=Pepper0

alias pepper_run_ros='roslaunch naoqi_driver naoqi_driver.launch roscore_ip:=$ROS_MASTER_IP network_interface:=$ROS_INTERFACE namespace:=$NAMESPACE'

source /home/nao/.ros-root/ros1_inst/setup.bash
