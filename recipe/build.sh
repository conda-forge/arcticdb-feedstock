#!/bin/bash

cp $RECIPE_DIR/setup.py .

export ARCTICDB_USING_CONDA=1

# do this only when cross compiling TODO
cp $BUILD_PREFIX/bin/protoc $PREFIX/bin/protoc

CMAKE_BUILD_PARALLEL_LEVEL=1 $PYTHON -m pip install . -vv
