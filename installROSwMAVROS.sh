#!/bin/bash
# Install Robot Operating System (ROS) on NVIDIA Jetson TX
# Maintainer of ARM builds for ROS is http://answers.ros.org/users/1034/ahendrix/
# Information from:
# http://wiki.ros.org/kinetic/Installation/UbuntuARM

# Red is 1
# Green is 2
# Reset is sgr0

#if [ $(id -u) -ne 0 ]; then
#   echo >&2 "Must be run as root"
#   exit 1
#fi

set -e
set -x

pushd /home/apsync

function usage
{
    echo "Usage: ./installROS.sh [[-p package] | [-h]]"
    echo "Install ROS Kinetic"
    echo "Installs ros-kinetic-ros-base as default base package; Use -p to override"
    echo "-p | --package <packagename>  ROS package to install"
    echo "                              Multiple usage allowed"
    echo "                              Must include one of the following:"
    echo "                               ros-kinetic-ros-base"
    echo "                               ros-kinetic-desktop"
    echo "                               ros-kinetic-desktop-full"
    echo "-h | --help  This message"
}

function shouldInstallPackages
{
    tput setaf 1
    echo "Your package list did not include a recommended base package"
    tput sgr0
    echo "Please include one of the following:"
    echo "   ros-kinetic-ros-base"
    echo "   ros-kinetic-desktop"
    echo "   ros-kinetic-desktop-full"
    echo ""
    echo "ROS not installed"
}

# Iterate through command line inputs
packages=()
while [ "$1" != "" ]; do
    case $1 in
        -p | --package )        shift
                                packages+=("$1")
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
# Check to see if other packages were specified
# If not, set the default base package
if [ ${#packages[@]}  -eq 0 ] ; then
 packages+="ros-kinetic-ros-base"
fi
echo "Packages to install: "${packages[@]}
# Check to see if we have a ROS base kinda thingie
hasBasePackage=false
for package in "${packages[@]}"; do
  if [[ $package == "ros-kinetic-ros-base" ]]; then
     hasBasePackage=true
     break
  elif [[ $package == "ros-kinetic-desktop" ]]; then
     hasBasePackage=true
     break
  elif [[ $package == "ros-kinetic-desktop-full" ]]; then
     hasBasePackage=true
     break
  fi
done
if [ $hasBasePackage == false ] ; then
   shouldInstallPackages
   exit 1
fi

# Let's start installing!

tput setaf 2
echo "Adding repository and source list"
tput sgr0
sudo apt-add-repository universe
sudo apt-add-repository multiverse
sudo apt-add-repository restricted

# Setup sources.lst
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 0xB01FA116
# Installation
tput setaf 2
echo "Updating apt-get"
tput sgr0
sudo apt-get update
tput setaf 2
echo "Installing ROS"
tput sgr0
# This is where you might start to modify the packages being installed, i.e.
# sudo apt-get install ros-kinetic-desktop

# Here we loop through any packages passed on the command line
# Install packages ...
for package in "${packages[@]}"; do
  sudo apt-get install $package -y
done

# Add Individual Packages here
# You can install a specific ROS package (replace underscores with dashes of the package name):
# sudo apt-get install ros-kinetic-PACKAGE
# e.g.
# sudo apt-get install ros-kinetic-navigation
#
# To find available packages:
# apt-cache search ros-kinetic
#
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
sudo apt-get install ros-kinetic-teleop-twist-keyboard -y
sudo apt-get install ros-kinetic-teleop-twist-joy -y
sudo apt-get install ros-kinetic-image-transport -y
sudo apt-get install ros-kinetic-joint-trajectory-controller -y
sudo apt-get install ros-kinetic-joint-limits-interface -y
sudo apt-get install ros-kinetic-controller-manager -y
sudo apt-get install ros-kinetic-razor-imu-9dof -y
sudo apt-get install ros-kinetic-imu-transformer  -y
sudo apt-get install ros-kinetic-serial -y
# Install other utilities
sudo apt-get install ros-kinetic-mavros -y
sudo apt-get install ros-kinetic-rqt -y
sudo apt-get install ros-kinetic-rqt-common-plugins -y
sudo apt-get install ros-kinetic-rqt-robot-plugins -y

# Initialize rosdep
tput setaf 2
echo "Installing rosdep"
tput sgr0
sudo apt-get install python-rosdep -y
# Certificates are messed up on the Jetson for some reason
sudo c_rehash /etc/ssl/certs
# Initialize rosdep
tput setaf 2
echo "Initializaing rosdep"
tput sgr0
sudo rm /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init
# To find available packages, use:
rosdep update
# Environment Setup - Don't add /opt/ros/kinetic/setup.bash if it's already in bashrc
grep -q -F 'source /opt/ros/kinetic/setup.bash' ~/.bashrc || echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
source ~/.bashrc
# Install rosinstall
tput setaf 2
echo "Installing rosinstall tools"
tput sgr0
sudo apt-get install python-rosinstall python-rosinstall-generator python-wstool python-catkin-tools build-essential -y
tput setaf 2
echo "Setup Catking Workspace"
rm -rf AionR1_ws
mkdir -p AionR1_ws/src
pushd AionR1_ws
catkin init
pushd src
rm -rf aion_r1
git clone https://github.com/aionrobotics/aion_r1.git
popd
catkin_make
popd

echo "Add source Catking WS to .bashrc (todo)"

grep -q -F 'source /home/apsync/AionR1_ws/devel/setup.bash' ~/.bashrc || echo "source /home/apsync/AionR1_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc
#LINE="source ~/AionR1_ws/devel/setup.bash"
#perl -pe "s%^exit 0%$LINE\\n\\nexit 0%" -i /home/apsync/.bashrc

echo "Install geographiclib datasets"
sudo /opt/ros/kinetic/lib/mavros/install_geographiclib_datasets.sh

echo "Replace mavlink-router.conf file with modified one"
cp /home/apsync/AionR1_ws/src/aion_r1/r1_control/config/mavlink-router.conf /home/apsync/start_mavlink-router

echo "Installation complete! Please reboot for changes to take effect"
tput sgr0
