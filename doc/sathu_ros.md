# Sathu's notes on setting up an Ubuntu VM with ROS

Install 64-bit ARM (Aarch64) desktop image ISO for Ubuntu 24.04.4
(Noble Numbat):

<https://cdimage.ubuntu.com/releases/noble/release/ubuntu-24.04.4-desktop-arm64.iso>

In UTM, start the VM with the ISO, give it 30-60 GiB storage, and install
Ubuntu. When finished, quit and remove the ISO from the VM image in UTM. Then
start the VM.

Ros Kilted Kaiju install guide:
<https://docs.ros.org/en/kilted/Installation/Ubuntu-Install-Debs.html>

Open a terminal and run the following:

```sh
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

sudo apt install git vim curl software-properties-common
sudo add-apt-repository universe

export ROS_APT_SOURCE_VERSION=$(curl -s \
	https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest |
	grep -F "tag_name" | awk -F\" '{print $4}')

curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME})_all.deb"
sudo dpkg -i /tmp/ros2-apt-source.deb

sudo apt update && sudo apt upgrade
sudo apt install ros-kilted-desktop-full

# Source (add to ~/.bashrc to persist)
. /opt/ros/kilted/setup.bash
```
# Kjør bare server + bruk RViz

Kjør:

"ros2 launch turtlebot3_gazebo empty_world.launch.py gui:=false"

Ignorer GUI-prosessen som dør.

Deretter i nytt terminalvindu:

"ros2 launch turtlebot3_bringup rviz2.launch.py"

# RViz bruker annen rendering og krasjer ikke. Dette er det de fleste ARM-brukere gjør akkurat nå.





roslaunch myagv_odometry
myagv_active.launch
