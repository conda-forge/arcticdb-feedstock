@echo off
setlocal EnableDelayedExpansion

:: Some `CMAKE_*` variables (in particular CMAKE_GENERATOR_{PLATFORM,TOOLSET})
:: are set by mamba / micromamba / conda when the environment is activated.
:: See: https://github.com/conda-forge/vc-feedstock/blob/c6bb71096319ff21ac8b75f7d91183be914c3d6b/recipe/activate.bat#L87-L131
:: The values which are chosen prevent Ninja to be used as a generator with MSVC.
:: We override those values so that we can.
set CMAKE_GENERATOR_PLATFORM=
set CMAKE_GENERATOR_TOOLSET=

:: Use 'windows-cl-conda-release' as the cmake preset
set ARCTIC_CMAKE_PRESET=windows-cl-conda-release

:: Set environment variables
set ARCTICDB_USING_CONDA=1

:: Build and install package
%PYTHON% -m pip install . -vv --no-build-isolation --no-deps

if errorlevel 1 exit 1

echo Freeing up disk space
rmdir /s /q %SRC_DIR%\cpp\out
echo End of freeing up disk space

