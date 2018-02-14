#!/bin/bash
# Install Robot Operating System (ROS) on NVIDIA Jetson TX2
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/kinetic/Installation/UbuntuARM

# Setup sources.lst
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
# Installation
sudo apt-get update
sudo apt-get install ros-kinetic-ros-base -y
# Update repositories
sudo apt-add-repository universe
sudo apt-add-repository multiverse
sudo apt-get update
# Install utilities
sudo apt-get install bash-completion -y
sudo apt-get install command-not-found -y
sudo apt-get install htop -y
sudo apt-get install nano -y

# Add Individual Packages here
# You can install a specific ROS package (replace underscores with dashes of the package name):
# sudo apt-get install ros-kinetic-PACKAGE
# e.g.
# sudo apt-get install ros-kinetic-navigation
# To find available packages:
# apt-cache search ros-kinetic
sudo apt-get install ros-kinetic-navigation -y
sudo apt-get install ros-kinetic-xacro -y
sudo apt-get install ros-kinetic-robot-state-publisher -y
sudo apt-get install ros-kinetic-joint-state-controller -y
sudo apt-get install ros-kinetic-diff-drive-controller -y
sudo apt-get install ros-kinetic-robot-localization -y
sudo apt-get install ros-kinetic-twist-mux -y
sudo apt-get install ros-kinetic-interactive-marker-twist-server -y
sudo apt-get install ros-kinetic-opencv-apps -y
sudo apt-get install ros-kinetic-gazebo-ros -y
sudo apt-get install ros-kinetic-gmapping -y
sudo apt-get install ros-kinetic-joy -y
sudo apt-get install ros-kinetic-diagnostic-aggregator -y
sudo apt-get install ros-kinetic-teleop-twist-joy -y
sudo apt-get install ros-kinetic-image-transport -y
sudo apt-get install ros-kinetic-joint-trajectory-controller -y
sudo apt-get install ros-kinetic-joint-limits-interface -y
sudo apt-get install ros-kinetic-controller-manager -y
sudo apt-get install ros-kinetic-razor-imu-9dof -y
sudo apt-get install ros-kinetic-imu-transformer  -y
sudo apt-get install ros-kinetic-serial -y

# Install other utilities
sudo apt-get install libpcl1 -y
sudo apt-get install libopencv-videostab2.4v5 -y
sudo apt-get install joystick -y
sudo apt-get install libncurses-dev -y

# Initialize rosdep
sudo apt-get install python-rosdep -y
# Certificates are messed up on the Jetson for some reason
sudo c_rehash /etc/ssl/certs
# Initialize rosdep
sudo rosdep init
# To find available packages, use:
rosdep update
# Environment Setup - Don't add /opt/ros/kinetic/setup.bash if it's already in bashrc
grep -q -F 'source /opt/ros/kinetic/setup.bash' ~/.bashrc || echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
# Install rosinstall
sudo apt-get install python-rosinstall -y

# Setup Catkin Workspace
setupCatkinWorkspace.sh
