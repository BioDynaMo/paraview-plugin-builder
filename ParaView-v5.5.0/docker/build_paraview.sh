#!/bin/sh

set -e

readonly paraview_version="5.5"
readonly paraview_version_patch="0"
readonly paraview_version_full="${paraview_version}.${paraview_version_patch}"
readonly url="https://gitlab.kitware.com/paraview/paraview-superbuild.git"

readonly workdir="$HOME/misc/code/paraview"
readonly srcdir="$workdir/paraview-superbuild"
readonly builddir="$workdir/ParaView-v${paraview_version_full}"

mkdir -p "$builddir"
cd "$workdir"
git clone "$url"
cd "$srcdir"
git submodule update --init
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -C $HOME/paraviewSuperbuildLinux550.cmake ../paraview-superbuild
make
