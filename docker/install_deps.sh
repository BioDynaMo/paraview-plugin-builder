#!/bin/sh

# Install packages required for CMake
yum install -y curl-devel make

# Install packages required for ParaView
yum install -y \
    git-core chrpath libtool gperf\
    libX11-devel libXdamage-devel libXext-devel libXt-devel libXi-devel \
    libxcb-devel xorg-x11-xtrans-devel libXcursor-devel libXft-devel \
    libXinerama-devel libXrandr-devel libXrender-devel \
    mesa-libGL-devel mesa-libGLU-devel mesa-dri-drivers \
    dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts \
    xkeyboard-config which

# Install a newer set of compilers from the Software Collections repos
yum install -y centos-release-scl yum-utils
yum-config-manager --enable centos-sclo-rh-testing
yum install -y \
    devtoolset-6-gcc devtoolset-6-gcc-c++ devtoolset-6-gcc-gfortran \
    devtoolset-4-gcc devtoolset-4-gcc-c++ devtoolset-4-gcc-gfortran \
    python27

# Cleanup
yum clean all
