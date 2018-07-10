#!/bin/bash

echo "Enter Arduino port name"
read portname
export portname
echo "Enter experiment number"
read num
export num

gnome-terminal --tab -e 'bash -c "roscore"'

gnome-terminal --tab -e 'bash -c "rosrun rosserial_python serial_node.py /dev/$portname"' & sleep 2

gnome-terminal --tab -e 'bash -c "roslaunch velodyne_pointcloud VLP16_points.launch"'

gnome-terminal --tab -e 'bash -c "cd catkin_ws/; source devel/setup.bash; catkin_make; roslaunch loam_velodyne hector_loam_velodyne.launch"'

sleep 10

wmctrl -a michael@michael-VirtualBox
read -p "Press Enter to start recording"

gnome-terminal --tab -e 'bash -c "rosbag record -O Experiment/experiment${num}.bag /velodyne_cloud_registered; rosrun pcl_ros bag_to_pcd Experiment/experiment${num}.bag /velodyne_cloud_registered Experiment/experiment${num}"'
