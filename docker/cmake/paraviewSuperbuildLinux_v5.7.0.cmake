# Activate testing
SET(BUILD_TESTING ON CACHE BOOL "")

# Debug build
SET(CMAKE_BUILD_TYPE "Release" CACHE STRING "")


SET(BUILD_SHARED_LIBS ON CACHE BOOL "")
SET(DIY_SKIP_SVN ON CACHE BOOL "")
SET(ENABLE_acusolve ON CACHE BOOL "")
SET(ENABLE_adios2 ON CACHE BOOL "")
SET(ENABLE_boost ON CACHE BOOL "")
SET(ENABLE_boxlib ON CACHE BOOL "")
SET(ENABLE_cosmotools ON CACHE BOOL "")
SET(ENABLE_ffmpeg ON CACHE BOOL "")
SET(ENABLE_fontconfig ON CACHE BOOL "")
SET(ENABLE_glu ON CACHE BOOL "")
SET(ENABLE_h5py ON CACHE BOOL "")
SET(ENABLE_las ON CACHE BOOL "")
SET(ENABLE_matplotlib ON CACHE BOOL "")
SET(ENABLE_mesa ON CACHE BOOL "")
SET(ENABLE_mili ON CACHE BOOL "")
SET(ENABLE_mpi ON CACHE BOOL "")
SET(ENABLE_netcdf ON CACHE BOOL "")
SET(ENABLE_numpy ON CACHE BOOL "")
SET(ENABLE_nvidiaindex ON CACHE BOOL "")
SET(ENABLE_ospray ON CACHE BOOL "")
SET(ENABLE_paraview ON CACHE BOOL "")
SET(ENABLE_paraviewgettingstartedguide ON CACHE BOOL "")
SET(ENABLE_paraviewtutorial ON CACHE BOOL "")
SET(ENABLE_paraviewtutorialdata ON CACHE BOOL "")
SET(ENABLE_paraviewusersguide ON CACHE BOOL "")
SET(ENABLE_paraviewweb ON CACHE BOOL "")
SET(ENABLE_python ON CACHE BOOL "")
SET(ENABLE_python2 OFF CACHE BOOL "")
SET(ENABLE_python3 ON CACHE BOOL "")
SET(ENABLE_qt5 ON CACHE BOOL "")
SET(ENABLE_scipy ON CACHE BOOL "")
SET(ENABLE_silo ON CACHE BOOL "")
SET(ENABLE_tbb ON CACHE BOOL "")
SET(ENABLE_visitbridge ON CACHE BOOL "")
SET(ENABLE_visrtx OFF CACHE BOOL "") # not downloading from china ?
SET(ENABLE_vistrails ON CACHE BOOL "")
SET(ENABLE_vortexfinder2 ON CACHE BOOL "")
SET(ENABLE_vrpn ON CACHE BOOL "")
SET(ENABLE_vtkm ON CACHE BOOL "")
SET(ENABLE_xdmf3 ON CACHE BOOL "")
SET(ENABLE_zfp ON CACHE BOOL "")
SET(PARAVIEW_DEFAULT_SYSTEM_GL ON CACHE BOOL "")
SET(Qt5_DIR "/home/buildslave/misc/root/qt5/lib/cmake/Qt5" CACHE PATH "")
SET(USE_NONFREE_COMPONENTS ON CACHE BOOL "")
SET(USE_SYSTEM_qt5 ON CACHE BOOL "")
SET(vtkm_SOURCE_SELECTION "for-git" CACHE STRING "")