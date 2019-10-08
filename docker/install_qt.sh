#!/bin/sh

set -e

readonly common_sb_url="https://gitlab.kitware.com/paraview/common-superbuild.git"
readonly commit="b33d663ed7299fdbfdac118a377f57dcb2c710f7"

readonly workdir="$HOME/misc/code/qt5"
readonly srcdir="$workdir/src"
readonly builddir="$workdir/build"

readonly cmake_root="$HOME/misc/root/cmake"

PATH="$PATH:$cmake_root/bin"

mkdir -p "$builddir"
git clone "${common_sb_url}" "$srcdir"
cd "$srcdir"
git checkout "$commit"

cd "$builddir"
cmake \
  -DENABLE_qt5:BOOL=ON \
  "-Dqt_install_location:PATH=$HOME/misc/root/qt5" \
  "-Dqt5_SOURCE_SELECTION:STRING=5.10" \
  -GNinja \
  "$srcdir/standalone-qt"
ninja

rm -rf "$workdir"
