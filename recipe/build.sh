#!/bin/bash

export ARCTICDB_USING_CONDA=1
export CMAKE_BUILD_PARALLEL_LEVEL=1

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  # otherwise we get the wrong binary when 
  # "compiling" the protobuf files
  rm $PREFIX/bin/protoc
  ln -s $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc
fi

 $PYTHON -m pip install . -vv --no-build-isolation --no-deps
