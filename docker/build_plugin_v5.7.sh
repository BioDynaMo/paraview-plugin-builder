#!/bin/sh

set -e

readonly workdir="$HOME/misc/code/plugin"
readonly srcdir="$workdir/src"
readonly builddir="$workdir/build"

rm -rf "$workdir"
mkdir -p "$builddir"
mkdir -p "$srcdir"
cd "$srcdir"
tar -xzvf $HOME/plugin.tgz
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -C $HOME/plugin.cmake -DParaView_DIR=$HOME/misc/code/paraview/paraview-superbuild_build/install/lib/cmake/paraview-5.7/ -DQt5_DIR=$HOME/misc/root/qt5/lib/cmake/Qt5 -DCMAKE_BUILD_TYPE=Release ../src
make -j 8
