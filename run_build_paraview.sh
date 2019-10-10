#!/bin/bash

# Options management
usage() { echo "Usage: $0 [-c <6|7>] hashOrTag

An open-source docker based script to facilitate the building of plugins for the binary release of ParaView.

Options:
  -c   Version of CentOS to build ParaView with. Only 6 and 7 have been tested.
       There is a bug in docker with CentOS 6, add vsyscall=emulate to your kernel parameters.
       See README.md for more info.

hashOrTag:
  v*   A release tag of ParaView. the following versions are supported:
       v5.4.1, v5.5.0, v5.5.1, v5.5.2, v5.6.0, v5.6.1, v5.6.2, v5.7.0

  nightlyHash  A specific hash corresponding to a nightly build. Only hash after the last release tag
               are supported, the superbuild will always uses it last master and ParaView will be configured
               with the last version of the configuration." 1>&2; exit 1; }

while getopts ":c:" o; do
    case "${o}" in
        c)
            centos=${OPTARG}
            ((centos == 6 || centos == 7)) || usage
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))
hashOrTag=$1

if [ -z "${hashOrTag}" ]; then
    usage
fi

if [ -z "${centos}" ]; then
    centos=7
fi

# Prepare hashOrTag specific files
# Check if this is a release tag
if [[ "${hashOrTag}" == v* ]]
then
  # Check if it is a 5.7 build as it requires specific files
  if [[ "${hashOrTag}" == v5.7.? ]]
  then
    cp ./docker/build_plugin_v5.7.sh ./docker/build_plugin.sh
  else
    cp ./docker/build_plugin_older.sh ./docker/build_plugin.sh
  fi
  cp ./docker/build_paraview_release.sh ./docker/build_paraview.sh
else
  # If not, we suppose that it is a nightly build
  cp ./docker/build_paraview_nightly.sh ./docker/build_paraview.sh
  cp ./docker/build_plugin_nightly.sh ./docker/build_plugin.sh
  cp ./docker/cmake/paraviewSuperbuildLinux_nightly.cmake ./docker/cmake/paraviewSuperbuildLinux_${hashOrTag}.cmake
fi

# Build the docker image
echo "Building ParaView..."
docker build -t "paraview:${hashOrTag}" --build-arg hashOrTag=${hashOrTag} --build-arg centosVersion=${centos} ./docker/
echo "Done."

# Clean up the hashOrTag dependent files
rm ./docker/build_plugin.sh
rm ./docker/build_paraview.sh
if ! [[ "${hashOrTag}" == v* ]]
then
  rm ./docker/cmake/paraviewSuperbuildLinux_${hashOrTag}.cmake
fi
