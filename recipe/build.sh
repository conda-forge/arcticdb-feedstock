#!/bin/bash

cp $RECIPE_DIR/setup.py .

export ARCTICDB_USING_CONDA=1

CMAKE_BUILD_PARALLEL_LEVEL=1 $PYTHON -m pip install . -vv