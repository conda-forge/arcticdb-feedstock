#!/bin/bash

cp $RECIPE_DIR/setup.py .

export ARCTICDB_USING_CONDA=1

if [[ "$CONDA_BUILD_CROSS_COMPILATION" != "1" ]]; then
  rm $PREFIX/bin/protoc
  ln -s $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc
fi


CMAKE_BUILD_PARALLEL_LEVEL=1 $PYTHON -m pip install . -vv
