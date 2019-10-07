FROM centos:7
MAINTAINER Mathieu Westphal <mathieu.westphal@kitware.com>

ARG hashOrTag
RUN echo "Building ParaView Release $hashOrTag"

# Install packages required for CMake
RUN yum install -y curl-devel make

# Install packages required for buildslave
RUN yum install -y epel-release && \
    yum install -y python-virtualenv

# Install packages required for ParaView
RUN yum install -y \
    git-core chrpath libtool \
    libX11-devel libXdamage-devel libXext-devel libXt-devel libXi-devel \
    libxcb-devel xorg-x11-xtrans-devel libXcursor-devel libXft-devel \
    libXinerama-devel libXrandr-devel libXrender-devel \
    mesa-libGL-devel mesa-libGLU-devel mesa-dri-drivers \
    dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts \
    xkeyboard-config gperf which

# Install a newer set of compilers from the Software Collections repos
RUN yum install -y centos-release-scl yum-utils
RUN yum-config-manager --enable centos-sclo-rh-testing
RUN yum install -y \
        devtoolset-4-gcc devtoolset-4-gcc-c++ devtoolset-4-gcc-gfortran \
        python27

# Cleanup
RUN yum clean all

# Set up the buildslave user
RUN useradd -c buildslave -d /home/buildslave -M buildslave
RUN mkdir /home/buildslave
RUN chown buildslave:buildslave /home/buildslave

USER buildslave

# Install CMake
COPY install_cmake.sh /home/buildslave/install_cmake.sh
RUN scl enable devtoolset-4 -- sh /home/buildslave/install_cmake.sh

# Install Ninja
COPY install_ninja.sh /home/buildslave/install_ninja.sh
RUN scl enable devtoolset-4 -- sh /home/buildslave/install_ninja.sh

# Install Qt
COPY install_qt.sh /home/buildslave/install_qt.sh
RUN scl enable devtoolset-4 -- sh /home/buildslave/install_qt.sh

# Build ParaView
COPY build_paraview.sh /home/buildslave/build_paraview.sh
COPY cmake/paraviewSuperbuildLinux_$hashOrTag.cmake /home/buildslave/paraviewSuperbuildLinux.cmake
RUN scl enable devtoolset-4 -- sh /home/buildslave/build_paraview.sh $hashOrTag

# Prepare Plugin Building
COPY build_plugin.sh /home/buildslave/build_plugin.sh