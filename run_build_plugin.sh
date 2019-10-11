#!/bin/bash

# Options management
usage() { echo "Usage: $0 [-d <plugin pluginDir>] [-j jobs] hashOrTag

An open-source docker based script to facilitate the building of plugins for the binary release of ParaView.

Options:
  -d   Path to a directory containing a plugin. This directory should contain a CMakeLists.txt.
       If no directory is provided, this script will try to use a plugin.tgz file in the root directory.

  -j   Jobs : number of parallel jobs to build the plugin with. Default is 8.

hashOrTag:
  Must correspond to the tag of an existing docker image named 'paraview' built with
  the run_build_paraview.sh script

Notes:
  You might need to modify plugin.cmake in order to pass specific CMake options to your plugin." 1>&2; exit 1; }

nbJobs=8
while getopts ":d:j:h" o; do
    case "${o}" in
        d)
            pluginDir=${OPTARG}
            ;;
        j)
            nbJobs=${OPTARG}
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
if ! [ -z ${pluginDir} ]
then
    if [ -d ${pluginDir} ]
    then
        echo ${pluginDir}
        # Create an archive from the plugin
        tar -czvf plugin.tgz -C ${pluginDir} .
        deleteArchive=true
    else
        echo "Provided plugin directory does not exist. Ignoring."
    fi
fi

if ! [[ -f plugin.tgz ]]
then
     echo "No plugin.tgz archive found. Aborting."; exit 0;
fi

# Recover release configuration
source docker/releaseConfiguration.sh

devtoolset="${devtoolsets[${hashOrTag}]}"
if [ -z "${devtoolset}" ]; then
    devtoolset=6
fi

# Copy and build the plugin
docker create --name=paraview paraview:$1 /bin/sh -c "while true; do echo hello world; sleep 1; done"
docker start paraview
docker cp plugin.cmake paraview:/home/buildslave/
docker cp plugin.tgz paraview:/home/buildslave/
echo "Building the plugin for ParaView ${hashOrTag} with devtoolset-${devtoolset} using ${nbJobs} jobs ..."
docker exec paraview scl enable devtoolset-${devtoolset} -- sh /home/buildslave/build_plugin.sh ${nbJobs}
docker cp paraview:/home/buildslave/misc/code/plugin/build ./
docker stop paraview
docker rm paraview
echo "Done."

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
  # If not, we suppose that it is a nightly build
  cp ./build/lib64/paraview-5.7/plugins/*/*.so ./
fi
rm -rf ./build
rm -rf ./plugin.tgz
