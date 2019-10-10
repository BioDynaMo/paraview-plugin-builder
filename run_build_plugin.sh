#!/bin/bash

# Options management
usage() { echo "Usage: $0 [-f <plugin folder>] hashOrTag

an open-source docker based script to facilitate the building of plugin the binary release of ParaView

Options:
  -f   Path to a folder containing a plugin. This folder should contain a CMakeLists.txt.
       If no folder is provided, this script will try to use a plugin.tgz file in the root directory.

hashOrTag:
  Must correspond to the tag of an existing docker image named "paraview" built with
  the run_build_paraview.sh script

Notes:
  Modify plugin.cmake in order to pass specific cmake options to your plugin if needed" 1>&2; exit 1; }

while getopts ":f:h" o; do
    case "${o}" in
        f)
            folder=${OPTARG}
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

# Plugin archive management
deleteArchive=false
if ! [ -z ${folder} ]
then
    if [ -d ${folder} ]
    then
        echo ${folder}
        # Create an archive from the plugin
        tar -czvf plugin.tgz -C ${folder} .
        deleteArchive=true
    else
        echo "Provided folder does not exist. Ignoring."
    fi
fi

if ! [[ -f plugin.tgz ]]
then
     echo "No plugin.tgz archive found. Aborting."; exit 0;
fi

# Copy and build the plugin
docker create --name=paraview paraview:$1 /bin/sh -c "while true; do echo hello world; sleep 1; done"
docker start paraview
docker cp plugin.cmake paraview:/home/buildslave/
docker cp plugin.tgz paraview:/home/buildslave/
echo "Building Plugin"
docker exec paraview scl enable devtoolset-6 -- sh /home/buildslave/build_plugin.sh
docker cp paraview:/home/buildslave/misc/code/plugin/build ./
docker stop paraview
docker rm paraview

# Recover the plugin libraries, location can change depending of ParaView version
if [[ "$1" == v* ]]
then
  if [[ "$1" == v5.7.? ]]
  then
    cp ./build/lib64/paraview-5.7/plugins/*/*.so ./
  else
    cp ./build/lib*.so ./
  fi
else
  # if not, we suppose that it is a nightly build
  cp ./build/lib64/paraview-5.7/plugins/*/*.so ./
fi
rm -rf ./build
rm -rf ./plugin.tgz
