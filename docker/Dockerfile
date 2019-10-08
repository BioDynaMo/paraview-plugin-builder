FROM centos:7
MAINTAINER Mathieu Westphal <mathieu.westphal@kitware.com>

ARG hashOrTag
RUN echo "Building ParaView $hashOrTag"

COPY install_deps.sh /root/install_deps.sh
RUN sh /root/install_deps.sh

# Set up the buildslave user
RUN useradd -c buildslave -d /home/buildslave -M buildslave
RUN mkdir /home/buildslave
RUN chown buildslave:buildslave /home/buildslave

USER buildslave

# Install CMake
COPY install_cmake.sh /home/buildslave/install_cmake.sh
RUN scl enable devtoolset-6 -- sh /home/buildslave/install_cmake.sh

# Install Ninja
COPY install_ninja.sh /home/buildslave/install_ninja.sh
RUN scl enable devtoolset-6 -- sh /home/buildslave/install_ninja.sh

# Install Qt
COPY install_qt.sh /home/buildslave/install_qt.sh
RUN scl enable devtoolset-6 -- sh /home/buildslave/install_qt.sh

# Build ParaView
COPY build_paraview.sh /home/buildslave/build_paraview.sh
COPY cmake/paraviewSuperbuildLinux_$hashOrTag.cmake /home/buildslave/paraviewSuperbuildLinux.cmake
RUN scl enable devtoolset-6 -- sh /home/buildslave/build_paraview.sh $hashOrTag

# Prepare Plugin Building
COPY build_plugin.sh /home/buildslave/build_plugin.sh
