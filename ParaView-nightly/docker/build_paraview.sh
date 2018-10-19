#!/bin/sh

set -e

readonly paraview_nigthly_hash=$1
readonly url="https://gitlab.kitware.com/paraview/paraview-superbuild.git"
readonly pvurl="https://gitlab.kitware.com/paraview/paraview.git"

readonly workdir="$HOME/misc/code/paraview"
readonly srcdir="$workdir/paraview-superbuild"
readonly pvsrcdir="$workdir/paraview"
readonly builddir="$workdir/paraview-superbuild_build"

mkdir -p "$builddir"

cd "$workdir"
git clone "$pvurl"
cd "$pvsrcdir"
git checkout "$paraview_nigthly_hash"
git submodule update --init --recursive

cd "$workdir"
git clone "$url"
cd "$srcdir"
git submodule update --init --recursive
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -C $HOME/paraviewSuperbuildLinuxNightly.cmake ../paraview-superbuild
make
