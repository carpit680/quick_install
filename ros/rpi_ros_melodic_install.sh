#!/bin/bash -eu

# The MIT License
# Copyright (c) 2021 Arpit Chauhan

#set -x

version=`lsb_release -sc`
echo ""
echo "INSTALLING ROS-Comm USING quick_ros_install --------------------------------"
echo ""
echo "Checking the RaspberryPi OS version"
case $version in
  "buster")
  ;;
  *)
    echo "ERROR: This script will only work on RaspberryPi OS buster. Exit."
    exit 0
esac


echo "Add the ROS repository"
if [ ! -e /etc/apt/sources.list.d/ros-latest.list ]; then
  sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
fi

echo "Download the ROS keys"
roskey=`apt-key list | grep "ROS Builder"` && true # make sure it returns true
if [ -z "$roskey" ]; then
  echo "No ROS key, adding"
  sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
fi

echo "Updating & upgrading all packages"
sudo apt-get update
sudo apt-get dist-upgrade -y

echo "Installing Bootstrap Dependencies"
sudo apt install -y python-rosdep \
   python-rosinstall-generator \
   python-wstool \
   python-rosinstall \
   build-essential \
   cmake

# Only init if it has not already been done before
if [ ! -e /etc/ros/rosdep/sources.list.d/20-default.list ]; then
  echo "Initializing rosdep"
  sudo rosdep init
fi
rosdep update

echo "Installing ROS-Comm"
mkdir -p ~/ros_catkin_ws
cd ~/ros_catkin_ws
rosinstall_generator ros_comm --rosdistro melodic --deps --wet-only --tar > melodic-ros_comm-wet.rosinstall 

wstool init src melodic-ros_comm-wet.rosinstall

rosdep install -y --from-paths src --ignore-src --rosdistro melodic -r --os=debian:buster

sudo ./src/catkin/bin/catkin_make_isolated --install -DCMAKE_BUILD_TYPE=Release --install-space /opt/ros/melodic

echo "Modifying bashrc/zshrc to source ROS setup files automatically."
if [ -e ~/.zshrc ] 
then
    echo "source /opt/ros/melodic/setup.zsh" >> ~/.zshrc
    source ~/.zshrc
else
    echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
    source ~/.bashrc
fi

echo "Done installing ROS-Comm."

exit 0