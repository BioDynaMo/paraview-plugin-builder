ARG centosVersion
FROM centos:$centosVersion
MAINTAINER Mathieu Westphal <mathieu.westphal@kitware.com>

COPY install_deps.sh /root/install_deps.sh
RUN sh /root/install_deps.sh

# Set up the buildslave user
RUN useradd -c buildslave -d /home/buildslave -M buildslave
RUN mkdir /home/buildslave
RUN chown buildslave:buildslave /home/buildslave

USER buildslave

ARG devtoolset

# Install CMake
COPY install_cmake.sh /home/buildslave/install_cmake.sh
RUN scl enable devtoolset-$devtoolset -- sh /home/buildslave/install_cmake.sh

# Install Ninja
COPY install_ninja.sh /home/buildslave/install_ninja.sh
RUN scl enable devtoolset-$devtoolset -- sh /home/buildslave/install_ninja.sh

# Install Qt
ARG qthash
COPY install_qt.sh /home/buildslave/install_qt.sh
RUN scl enable devtoolset-$devtoolset -- sh /home/buildslave/install_qt.sh $qthash

ARG hashOrTag
ARG pythonVersion
ARG fullBuild
ARG centosVersion
ARG nbJobs
RUN echo "Building ParaView $hashOrTag on CentOS $centosVersion with devtoolset-$devtoolset using $nbJobs jobs ..."

# Build ParaView
COPY build_paraview.sh /home/buildslave/build_paraview.sh
COPY cmake/paraviewSuperbuildLinux_$hashOrTag.cmake /home/buildslave/paraviewSuperbuildLinux.cmake
RUN scl enable devtoolset-$devtoolset -- sh /home/buildslave/build_paraview.sh $hashOrTag $pythonVersion $fullBuild $nbJobs

# Prepare Plugin Building
COPY build_plugin.sh /home/buildslave/build_plugin.sh
