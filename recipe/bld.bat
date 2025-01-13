@echo off
setlocal EnableDelayedExpansion

:: Set environment variables
set ARCTICDB_USING_CONDA=1
:: Compiling ArcticDB with all cores might freeze machines due to swapping.
:: We build with only 1 core to prevent these freezes from happening.
set CMAKE_BUILD_PARALLEL_LEVEL=1


:: Workaround for: https://github.com/conda-forge/glog-feedstock/issues/26
:: Required to be able to include headers from glog since glog 0.7.
:: See: https://github.com/google/glog/pull/1030
set "CXXFLAGS=%CXXFLAGS% -DGLOG_USE_GLOG_EXPORT"

:: Build and install package
%PYTHON% -m pip install . -vv --no-build-isolation --no-deps

if errorlevel 1 exit 1
