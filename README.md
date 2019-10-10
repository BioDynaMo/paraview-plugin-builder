Introduction
============
ParaViewPluginBuilder is an open-source [docker][] based script to
facilitate the building of plugin the binary release of [ParaView][]

[ParaView]: http://www.paraview.org
[docker]: https://www.docker.com

TLDR
====

```
./run_build_paraview releaseTag
./run_build_plugin -f /path/to/plugin/folder releaseTag
```

Building
========

The building is divided in two phases
There are two scripts, one for each part of the build.

* Building a specific version of ParaView

* Building a provided plugin of an already builded version of ParaView

This very convienent is it allows fast building of plugins once the
targeted version of ParaView has been built

Building ParaView
=================

To build paraview, use the run_build_paraview.sh script from the root directory.
Release and Nightly hash build are supported. Just provide the tag of the release
of the hash as the last positional argument.

If needed provide the version of centos to build with. Default is 7.

* `run_build_paraview [-c <6|7>] hashOrTag`
* eg: `./run_build_paraview.sh -c 7 v5.6.2`
* eg: `./run_build_paraview.sh 83a6c73`

The following release versions are supported and tested
 * v5.4.1 # boxlib bug
 * v5.5.0 # boxlib bug
 * v5.5.1 # boxlib bug
 * v5.5.2 # boxlib bug
 * v5.6.0 # to test with new version
 * v5.6.1
 * v5.6.2
 * v5.7.0 # libxml2 bug

About nightly hash builds. Only nightly hash after the last release tag are supported,
the superbuild will always uses it last master and ParaView will be configured with the last version
of the configuration.

The nightly hash is present in the name of the nightly release download :
ParaView-5.7.0-492-g83a6c73-MPI-Linux-Python3.7-64bit.tgz hash is `83a6c73`.

Once the script finished a new image named paraview and tagged `hashOrTag` should appear:

```
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
paraview            v5.6.2              4b7eafdec82c        2 hours ago         7.62GB
centos              7                   67fa590cfc1c        6 weeks ago         202MB
```

About Centos6
=============

Even though we support Centos6, there is a [bug][] in docker when using
Centos6 because of spectre mitigation. It is possible to work around it
by adding `vsyscall=emulate` to kernel parameters.
Use at your own risk.

[bug]: https://github.com/CentOS/sig-cloud-instance-images/issues/103

Building a plugin
=================

To build a plugin, first make sure that the targeted version of ParaView have been built,
then use the run_build_plugin script from the root directory
use -f option to point to the folder containing a plugin
and provide it the tag to select the version of ParaView to build with.
* `run_build_plugin -f /path/to/plugin/folder hashOrTag`
* eg: `./run/build_plugin.sh -f /home/user/myPlugin v5.6.2`
* eg: `./run/build_plugin.sh -f /home/user/myPlugin 83a6c73`

If no folder is provided, the script will try to use a plugin.tgz in the root directory.

If specific cmake options have to be passed during the configuration of the plugin,
they can be specified in the plugin.cmake file

License
=======

ParaViewPluginBuilder is distributed under the OSI-approved BSD 3-clause License.
See [License.txt][] for details. For additional licenses, refer to
[ParaView Licenses][].

[Copyright.txt]: Copyright.txt
[ParaView Licenses]: http://www.paraview.org/paraview-license/
