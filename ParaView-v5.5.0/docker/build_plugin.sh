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
$HOME/misc/root/cmake/bin/cmake -C $HOME/plugin.cmake -DParaView_DIR=$HOME/misc/code/paraview/ParaView-v5.5.0/superbuild/paraview/build/ -DQt5_DIR=$HOME/misc/root/qt5/lib/cmake/Qt5 -DMPI_C_LIBRARIES=$HOME/misc/code/paraview/ParaView-v5.5.0/install/lib/libmpi.so -DMPI_C_INCLUDE_PATH=$HOME/misc/code/paraview/ParaView-v5.5.0/install/include -DMPI_CXX_LIBRARIES="$HOME/misc/code/paraview/ParaView-v5.5.0/install/lib/libmpicxx.so;$HOME/misc/code/paraview/ParaView-v5.5.0/install/lib/libmpi.so"  -DMPI_CXX_INCLUDE_PATH=$HOME/misc/code/paraview/ParaView-v5.5.0/install/include -DMPI_CXX_COMPILER=/home/buildslave/misc/code/paraview/ParaView-v5.5.0/install/bin/mpicxx -DMPI_C_COMPILER=/home/buildslave/misc/code/paraview/ParaView-v5.5.0/install/bin/mpicc -DCMAKE_BUILD_TYPE=Release ../src
make
