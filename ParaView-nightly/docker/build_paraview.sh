#!/bin/sh

set -e

readonly paraview_nigthly_hash="63ddf4d"
readonly paraview_version="5.4"
readonly paraview_version_patch="1"
readonly paraview_version_full="${paraview_version}.${paraview_version_patch}"
readonly url="https://gitlab.kitware.com/paraview/paraview-superbuild.git"
readonly pvurl="https://gitlab.kitware.com/paraview/paraview.git"

readonly workdir="$HOME/misc/code/paraview"
readonly srcdir="$workdir/paraview-superbuild"
readonly pvsrcdir="$workdir/paraview"
readonly builddir="$workdir/ParaView-v${paraview_version_full}"

mkdir -p "$builddir"

cd "$workdir"
git clone "$pvurl"
cd "$pvsrcdir"
git checkout "$paraview_nigthly_hash"
git submodule update --init
cd "VTK"
git submodule update --init

cd "$workdir"
git clone "$url"
cd "$srcdir"
git submodule update --init
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -C $HOME/paraviewSuperbuildLinux541Nightly.cmake ../paraview-superbuild
make
