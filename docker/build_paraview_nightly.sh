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
if [ $? -ne 0 ]; then
    echo "Unknown nightly hash: ${paraview_nigthly_hash}"
    exit 1
fi


git submodule update --init --recursive

cd "$workdir"
git clone "$url"
cd "$srcdir"
git submodule update --init --recursive
cd "$builddir"
$HOME/misc/root/cmake/bin/cmake -DSUPERBUILD_PROJECT_PARALLELISM=$4 -DFULL_BUILD=$3 -DPYTHON_VERSION=$2  -C $HOME/paraviewSuperbuildLinux.cmake ../paraview-superbuild
make
