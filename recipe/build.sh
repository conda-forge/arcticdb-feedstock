#!/bin/bash

export ARCTICDB_USING_CONDA=1
# Compiling ArcticDB with all cores might freeze machines due to swapping.
# We build with only 1 core to prevent these freezes from happening.
export CMAKE_BUILD_PARALLEL_LEVEL=1

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then


  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/gnuconfig/config.* .

  # We have to `protoc` from the build instead of the one from the host
  # in order to get a usable binary to compile the protobuf files.
  rm $PREFIX/bin/protoc
  ln -s $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc
fi

$PYTHON -m pip install . -vv --no-build-isolation --no-deps
