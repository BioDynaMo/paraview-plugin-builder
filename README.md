Introduction
============
ParaViewPluginBuilder is an open-source [docker][] based script to
facilitate the building of plugin for the binary release of [ParaView][].
This tool is developed by [Kitware SAS][].

[ParaView]: http://www.paraview.org
[docker]: https://www.docker.com
[Kitware SAS]: https://www.kitware.eu

TLDR
====

```
./run_build_paraview releaseTag
./run_build_plugin -d /path/to/plugin/directory releaseTag
```

Building
========

The building is divided in two phases
There are two scripts, one for each part of the build.

 * Building a specific version of ParaView
 * Building a provided plugin of an already builded version of ParaView

This is very convienent as it allows fast building of plugins once the
targeted version of ParaView has been built

Building ParaView
=================

To build ParaView, use the `run_build_paraview.sh` script from the main directory.
As parameter, just provide a release tag or a nightly hash (both are supported)
If needed (advanced cases), you can provide the version of CentOS to build with.
Default version is 7.
If needed (advanced cases), you can require that a full build of ParaView instead
of a minimal one. It will take longer to build.

* `run_build_paraview [-c <6|7>] [-f] hashOrTag`
* eg: `./run_build_paraview.sh -c 7 v5.6.2`
* eg: `./run_build_paraview.sh -f 83a6c73`

The following release versions are supported and tested:
 * v5.4.1 # to test with new version
 * v5.5.0 # to test with new version
 * v5.5.1 # to test with new version
 * v5.5.2 # to test with new version
 * v5.6.0 # to test with new version
 * v5.6.1 # to test with new version
 * v5.6.2 # to test with new version
 * v5.7.0 # to test with new version

About nightly hash builds: only nightly hash after the last release tag are supported.
The last master superbuild will always be used and ParaView will be configured with
the last version parameters.

The nightly hash is present in the name of the nightly release download :
ParaView-5.7.0-492-g83a6c73-MPI-Linux-Python3.7-64bit.tgz hash is `83a6c73`.

Once the script finished a new image named paraview and tagged `hashOrTag` should appear:

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
paraview            v5.6.2              4b7eafdec82c        2 hours ago         7.62GB
centos              7                   67fa590cfc1c        6 weeks ago         202MB
```

About CentOS 6
==============

CentOS is the Linux distribution currently used to generate the official
binaries of ParaView for Linux. However, there is a known [bug][] in
docker when using CentOS6 because of spectre mitigation.
It is possible to work around it by adding `vsyscall=emulate` to kernel parameters.
Use at your own risk!

As alternative, we use CentOS 7 by default and configure it with a toolset
compatible with the one used to build official ParaView binaries.


[bug]: https://github.com/CentOS/sig-cloud-instance-images/issues/103


Building a plugin
=================

To build a plugin, first make sure that the targeted version of ParaView has been built,
then use the `run_build_plugin` script.

As parameters, use `-d` option to specify the path that contains the plugin sources,
and specify the tag of the version of ParaView to build the plugin with.
Note that if no plugin directory is provided, the script tries to build the file `plugin.tgz`
in the script directory.

 * `run_build_plugin -d /path/to/plugin/directory hashOrTag`
 * eg: `./run_build_plugin.sh -d /home/user/myPlugin v5.6.2`
 * eg: `./run_build_plugin.sh -d /home/user/myPlugin 83a6c73`


If specific CMake options have to be passed during the configuration of the plugin,
they can be specified in the `plugin.cmake` file.

License
=======

ParaViewPluginBuilder is distributed under the OSI-approved BSD 3-clause License.
See [License.txt][] for details. For additional licenses, refer to the
[ParaView License][].

[License.txt]: License.txt
[ParaView License]: http://www.paraview.org/paraview-license/
