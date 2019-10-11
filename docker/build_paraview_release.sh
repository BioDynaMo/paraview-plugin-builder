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
git submodule update --init
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -DSUPERBUILD_PROJECT_PARALLELISM=$3 -DFULL_BUILD=$2 -C $HOME/paraviewSuperbuildLinux.cmake ../paraview-superbuild
make
