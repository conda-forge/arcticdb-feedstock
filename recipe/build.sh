#!/bin/bash

export ARCTICDB_USING_CONDA=1
# Compiling ArcticDB with all cores might freeze machines due to swapping
# around binary operators' template specialization expansion and compilation.
# See: https://github.com/man-group/ArcticDB/blob/master/cpp/arcticdb/processing/operation_dispatch_binary.hpp#L451-L473
# We build with only 2 cores to prevent these freezes from happening.
export CMAKE_BUILD_PARALLEL_LEVEL=2

# Required to be able to include headers from glog since glog 0.7
# See: https://github.com/google/glog/pull/1030
export CXXFLAGS="$CXXFLAGS -DGLOG_USE_GLOG_EXPORT"

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # Get an updated config.sub and config.guess
  # (see https://conda-forge.org/docs/maintainer/knowledge_base.html#cross-compilation)
  cp $BUILD_PREFIX/share/gnuconfig/config.* .

  # We have to `protoc` from the build instead of the one from the host
  # in order to get a usable binary to compile the protobuf files.
  rm $PREFIX/bin/protoc
  ln -s $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc
fi

$PYTHON -m pip install . -vv --no-build-isolation --no-deps
