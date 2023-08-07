#!/bin/bash

export ARCTICDB_USING_CONDA=1
# Compiling ArcticDB with all cores might freeze machines due to swapping.
# We build with only 1 core to prevent these freezes from happening.
export CMAKE_BUILD_PARALLEL_LEVEL=1

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # Get an updated config.sub and config.guess  
  # (see https://conda-forge.org/docs/maintainer/knowledge_base.html#cross-compilation)
  cp $BUILD_PREFIX/share/gnuconfig/config.* .

  # We have to `protoc` from the build instead of the one from the host
  # in order to get a usable binary to compile the protobuf files.
  rm $PREFIX/bin/protoc
  ln -s $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc

  # if we cross compile for apple 
  if [[ "$target_platform" == "osx-arm64" ]]; then
    echo "Cross compiling for apple silicon"

    # when cross compiling for apple silicon, we absolutely need to make sure
    # that there is no hard coded compiler in the cmake-preset / cmake-config.
    # while https://github.com/man-group/ArcticDB/pull/662 is not merged, we
    # need use a custom cmake preset file for apple silicon.
    cp $RECIPE_DIR/CMakePresetCrossCompileAppleSilicon.json $SRC_DIR/cpp/CMakePresets.json

  fi

fi

$PYTHON -m pip install . -vv --no-build-isolation --no-deps
