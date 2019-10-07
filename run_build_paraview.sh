# prepare hashOrTag specific files
# check if this is a release tag
if [[ "$1" == v* ]]
then
  # check if it is a 5.7 build as it requires specific files
  if [[ "$1" == v5.7.? ]]
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
  cp ./docker/cmake/paraviewSuperbuildLinux_nightly.cmake ./docker/cmake/paraviewSuperbuildLinux_$1.cmake
fi

# build the docker image
docker build -t "paraview:$1" --build-arg hashOrTag=$1 ./docker/

# clean up the hashOrTag dependent files
rm ./docker/build_plugin.sh
rm ./docker/build_paraview.sh
if ! [[ "$1" == v* ]]
then
  rm ./docker/cmake/paraviewSuperbuildLinux_$1.cmake
fi
