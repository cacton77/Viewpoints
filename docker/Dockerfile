ARG ROS_DISTRO=humble

##################################
# Base Image for Viewpoints Tool #
##################################
FROM ros:${ROS_DISTRO}-ros-base as base
ENV ROS_DISTRO=${ROS_DISTRO}
SHELL ["/bin/bash", "-c"]

# Install cli tools via apt
RUN apt-get update \
    && apt-get install -y wget curl neovim python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN python3 -m pip install open3d pytransform3d bayesian-optimization

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    cmake \
    git-all \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

ARG DEBIAN_FRONTEND=dialog

# Create base Colcon workspace with external dependencies
RUN mkdir -p /root/base_ws/src
# WORKDIR /root/base_ws/src
# COPY dependencies.repos .
# COPY ./auto_viewpoint_generation .
# RUN vcs import < dependencies.repos

# Build the base Colcon workspace, installing dependencies first.
WORKDIR /root/base_ws
RUN source /opt/ros/${ROS_DISTRO}/setup.bash \
    && apt-get update -y \
    # && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y \
    && colcon build --symlink-install

# TEMPORARY, COPY REPO TO SRC FOLDER UNBUILT
WORKDIR /root/base_ws/src
# COPY dependencies.repos .
COPY ./auto_viewpoint_generation ./auto_viewpoint_generation
# RUN vcs import < dependencies.repos


#############################################
# Overlay Image for Inspection Tool Control #
#############################################
FROM base AS overlay

# Create an overlay Colcon workspace
RUN mkdir -p /root/overlay_ws/src
WORKDIR /root/overlay_ws
RUN source /root/base_ws/install/setup.bash \
    && rosdep install --from-paths src --ignore-src --rosdistro ${ROS_DISTRO} -y \
    && colcon build --symlink-install

# Set up the entrypoint
COPY ./docker/entrypoint.sh /
COPY ./bashrc /root/.bashrc
ENTRYPOINT [ "/entrypoint.sh" ]


CMD ["bash"]