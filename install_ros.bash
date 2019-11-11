#!/bin/bash -exv

###############
# Before we install Ubuntu, it's important to install the right video drivers on your computer.
# Here, we are installing MESA drivers which has OpenGL driver support for linux.
sudo add-apt-repository ppa:ubuntu-x-swat/updates -y
sudo apt-get update
sudo apt-get dist-upgrade -y
###############

UBUNTU_VER=$(lsb_release -sc)
ROS_VER=kinetic
[ "$UBUNTU_VER" = "trusty" ] && ROS_VER=indigo

echo "deb http://packages.ros.org/ros/ubuntu $UBUNTU_VER main" > /tmp/$$-deb
sudo mv /tmp/$$-deb /etc/apt/sources.list.d/ros-latest.list

set +vx
while ! sudo apt-get install -y curl ; do
	echo '***WAITING TO GET A LOCK FOR APT...***'
	sleep 1
done
set -vx

curl -k https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | sudo apt-key add -
sudo apt-get update || echo ""

sudo apt-get install -y openssh-server

sudo apt-get install -y ros-${ROS_VER}-desktop-full

ls /etc/ros/rosdep/sources.list.d/20-default.list && sudo rm /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init 

###############
# This is important! If you are using any other OS based on Ubuntu/Debian but not Ubuntu itself, /
# you might have to run this line on a terminal separately when you see OS not detected error - /
# "OsNotDetected("Could not detect OS, tried %s" % attempted)"
export ROS_OS_OVERRIDE="ubuntu:xenial"
###############

rosdep update

sudo apt install -y python-rosinstall python-rosinstall-generator python-wstool build-essential python-catkin-tools


#[ "$ROS_VER" = "kinetic" ] && sudo apt-get install -y ros-${ROS_VER}-roslaunch

grep -F "source /opt/ros/$ROS_VER/setup.bash" ~/.bashrc ||
echo "source /opt/ros/$ROS_VER/setup.bash" >> ~/.bashrc

grep -F "ROS_MASTER_URI" ~/.bashrc ||
echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc

grep -F "ROS_HOSTNAME" ~/.bashrc ||
echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc

sudo apt-get install -y linux-headers-generic
sudo sh -c 'echo "deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://security.ubuntu.com/ubuntu xenial-security main restricted" > \
  /etc/apt/sources.list.d/official-source-repositories.list'
sudo apt-get update

sudo apt-get install -y ros-$ROS_VER-realsense-camera
# If you face issues at this stage, I encourage you to go through the link - /
# https://answers.ros.org/question/246015/installing-turtlebot-on-ros-kinetic/ /
# and perform the steps as mentioned to do away with the error /
# "Unable to locate package ros-kinetic-realsense-camera" 


sudo apt-get install -y g++ automake autoconf cmake
sudo apt-get install -y ros-$ROS_VER-librealsense ros-$ROS_VER-turtlebot ros-$ROS_VER-turtlebot-apps ros-$ROS_VER-turtlebot-interactions ros-$ROS_VER-turtlebot-simulator ros-$ROS_VER-kobuki-ftdi ros-$ROS_VER-ar-track-alvar-msgs


sudo usermod -aG dialout $USER


### instruction for user ###
set +xv

echo '*********INSTRUCTION***********'
echo '*execute the following command*'
echo '* $ source ~/.bashrc          *'
echo '*******************************'
source ~/.bashrc
