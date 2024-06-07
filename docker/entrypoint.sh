#!/bin/bash

# Source ROS 2
source /opt/ros/${ROS_DISTRO}/setup.bash
source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

# Source the base workspace, if built
if [ -f /root/advisor_ws/install/setup.bash ]
then
    source /root/advisor_ws/install/setup.bash
fi

# Source the overlay workspace, if built
if [ -f /root/dev_ws/install/setup.bash ]
then
    source /root/dev_ws/install/setup.bash
fi

exec "$@"