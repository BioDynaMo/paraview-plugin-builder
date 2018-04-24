docker create --name=paraview paraview:5.5.0 /bin/sh -c "while true; do echo hello world; sleep 1; done"
docker start paraview
docker cp plugin.cmake paraview:/home/buildslave/
docker cp plugin.tgz paraview:/home/buildslave/
echo "Building Plugin"
docker exec paraview scl enable devtoolset-4 -- sh /home/buildslave/build_plugin.sh
docker cp paraview:/home/buildslave/misc/code/plugin/build ./
docker stop paraview
docker rm paraview
cp ./build/lib*.so ./
rm -rf ./build
