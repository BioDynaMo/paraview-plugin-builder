#!/bin/sh

set -e

readonly url="https://gitlab.kitware.com/paraview/paraview-superbuild.git"

readonly workdir="$HOME/misc/code/paraview"
readonly srcdir="$workdir/paraview-superbuild"
readonly builddir="$workdir/paraview-superbuild_build"

mkdir -p "$builddir"
cd "$workdir"
git clone "$url"
cd "$srcdir"
git checkout $1
if [ $? -ne 0 ]; then
    echo "Unknown release tag in the ParaView superbuild ${1}"
    exit 1
fi

git submodule update --init
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -DSUPERBUILD_PROJECT_PARALLELISM=$4 -DFULL_BUILD=$3 -DPYTHON_VERSION=$2 -C $HOME/paraviewSuperbuildLinux.cmake ../paraview-superbuild
make

# The install directory can be found in /home/buildslave/misc/code/paraview/paraview-superbuild_build/install
