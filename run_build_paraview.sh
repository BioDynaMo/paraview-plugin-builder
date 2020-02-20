#!/bin/bash

# Options management
usage() { echo "Usage: $0 [-c <6|7>] [-p <2|3>] [-f] [-j jobs] hashOrTag

An open-source docker based script to facilitate the building of plugins for the binary release of ParaView.

Options:
  -c   CentOS version to build ParaView with. Only 6 and 7 are supported. Default is 7.
       There is a bug in docker with CentOS 6, add vsyscall=emulate to your kernel parameters.
       See README.md for more info.

  -p   Python version to build ParaView with. Only 2 and 3 are supported. Default is 3.
       This option is taken into account only with v5.7.X, v5.8.X and nightly hash

  -f   Full build : Pass this flag to enable all release options on the ParaView superbuild.
       It is not needed most of the time and will result in longer compilation of ParaView.

  -j   Jobs : number of parallel jobs to build ParaView with. Default is nproc+1.

hashOrTag:
  v*   A release tag of ParaView. the following versions are supported:
       v5.4.1, v5.5.0, v5.5.1, v5.5.2, v5.6.0, v5.6.1, v5.6.2, v5.7.0, v5.8.0

  nightlyHash  A specific hash corresponding to a nightly build. Only hash after the last release tag
               are supported, the superbuild will always use its last master and ParaView will be configured
               with the last version of the configuration." 1>&2; exit 1; }

centosVersion=7
fullBuild=OFF
let nbJobs=`nproc`+1
pythonVersion=3
while getopts ":c:p:fj:" o; do
    case "${o}" in
        c)
            centosVersion=${OPTARG}
            ((centosVersion == 6 || centosVersion == 7)) || usage
            ;;
        p)
            pythonVersion=${OPTARG}
            ((pythonVersion == 2 || pythonVersion == 3)) || usage
            ;;
        f)
            fullBuild=ON
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

# Recover release configuration
source docker/releaseConfiguration.sh

devtoolset="${devtoolsets[${hashOrTag}]}"
if [ -z "${devtoolset}" ]; then
    devtoolset=6
fi

qthash="${qthashes[${hashOrTag}]}"
if [ -z "${qthash}" ]; then
    qthash=b33d663ed7299fdbfdac118a377f57dcb2c710f7
fi

# Prepare hashOrTag specific files
# Check if this is a release tag
if [[ "${hashOrTag}" == v* ]]
then
  # check release tag does exist
  git ls-remote --heads --tags "https://gitlab.kitware.com/paraview/paraview.git" | grep -E "refs/(heads|tags)/${hashOrTag}$" >/dev/null
  if ! [[ "$?" -eq "0" ]]; then
    echo "Unknown release tag ${hashOrTag}"
    exit 1
  fi
  # Check if it is a 5.7 or 5.8 build as it requires specific files
  if [[ "${hashOrTag}" == v5.7.? ]]
  then
    cp ./docker/build_plugin_v5.7.sh ./docker/build_plugin.sh
  elif [[ "${hashOrTag}" == v5.8.? ]]
  then
    cp ./docker/build_plugin_v5.8.sh ./docker/build_plugin.sh
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
docker build -t "paraview:${hashOrTag}" \
  --build-arg hashOrTag=${hashOrTag} \
  --build-arg qthash=${qthash} \
  --build-arg centosVersion=${centosVersion} \
  --build-arg devtoolset=${devtoolset} \
  --build-arg pythonVersion=${pythonVersion} \
  --build-arg fullBuild=${fullBuild} \
  --build-arg nbJobs=${nbJobs} \
  ./docker/
echo "Done."

# Clean up the hashOrTag dependent files
rm ./docker/build_plugin.sh
rm ./docker/build_paraview.sh
if ! [[ "${hashOrTag}" == v* ]]
then
  rm ./docker/cmake/paraviewSuperbuildLinux_${hashOrTag}.cmake
fi
