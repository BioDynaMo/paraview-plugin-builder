#!/bin/bash

usage() { echo "Usage: $0 [-c <6|7>] hashOrTag" 1>&2; exit 1; }
showHelp() { echo "TODO" 1>&2; exit 1; }

while getopts ":c:h" o; do
    case "${o}" in
        c)
            centos=${OPTARG}
            ((centos == 6 || centos == 7)) || usage
            ;;
        h)
            showHelp
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

# prepare hashOrTag specific files
# check if this is a release tag
if [[ "${hashOrTag}" == v* ]]
then
  # check if it is a 5.7 build as it requires specific files
  if [[ "${hashOrTag}" == v5.7.? ]]
  then
    cp ./docker/build_plugin_v5.7.sh ./docker/build_plugin.sh
  else
    cp ./docker/build_plugin_older.sh ./docker/build_plugin.sh
  fi
  cp ./docker/build_paraview_release.sh ./docker/build_paraview.sh
else
  # if not, we suppose that it is a nightly build
  cp ./docker/build_paraview_nightly.sh ./docker/build_paraview.sh
  cp ./docker/build_plugin_nightly.sh ./docker/build_plugin.sh
  cp ./docker/cmake/paraviewSuperbuildLinux_nightly.cmake ./docker/cmake/paraviewSuperbuildLinux_${hashOrTag}.cmake
fi

# build the docker image
docker build -t "paraview:${hashOrTag}" --build-arg hashOrTag=${hashOrTag} --build-arg centosVersion=${centos} ./docker/

# clean up the hashOrTag dependent files
rm ./docker/build_plugin.sh
rm ./docker/build_paraview.sh
if ! [[ "${hashOrTag}" == v* ]]
then
  rm ./docker/cmake/paraviewSuperbuildLinux_${hashOrTag}.cmake
fi
