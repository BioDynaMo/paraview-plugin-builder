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
