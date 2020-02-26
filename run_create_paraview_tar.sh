#!/bin/bash

# Options management
usage() { echo "Usage: $0 [-j jobs] hashOrTag

An open-source docker based script to facilitate the building of plugins for the binary release of ParaView.

Options:
  -j   Jobs : Number of parallel jobs to build the plugin with. Default is nproc+1.

hashOrTag:
  Must correspond to the tag of an existing docker image named 'paraview' built with
  the run_build_paraview.sh script" 1>&2; exit 1; }

let nbJobs=`nproc`+1
while getopts ":bj:h" o; do
    case "${o}" in
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

# Copy and package the distribution
docker create --name=paraview_bdm paraview:bdm_${hashOrTag} /bin/sh -c "while true; do echo waiting; sleep 1; done"
docker start paraview_bdm
docker cp paraview_bdm:/home/buildslave/misc/code/paraview/paraview-superbuild_build/install ./
docker stop paraview_bdm
docker rm paraview_bdm
echo "Done."

cd install && tar -zcf paraview-${hashOrTag}.tar.gz *
cd ..
mv install/paraview-${hashOrTag}.tar.gz .
rm -rf ./install
