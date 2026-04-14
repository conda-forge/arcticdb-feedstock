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

:: Ensure standard protobuf .proto includes are available to setup.py's
:: `grpc_tools.protoc -Icpp/proto ...` invocation on Windows.
set "PROTO_DST=%SRC_DIR%\cpp\proto\google\protobuf"
set "PROTO_FROM_PREFIX=%PREFIX%\Library\include\google\protobuf"
set "PROTO_FROM_GRPC_TOOLS=%PREFIX%\Lib\site-packages\grpc_tools\_proto\google\protobuf"

if not exist "%SRC_DIR%\cpp\proto\google" mkdir "%SRC_DIR%\cpp\proto\google"

if exist "%PROTO_FROM_PREFIX%" (
  echo Copying protobuf includes from %PROTO_FROM_PREFIX%
  xcopy /E /I /Y "%PROTO_FROM_PREFIX%" "%PROTO_DST%\" >nul
) else if exist "%PROTO_FROM_GRPC_TOOLS%" (
  echo Copying protobuf includes from %PROTO_FROM_GRPC_TOOLS%
  xcopy /E /I /Y "%PROTO_FROM_GRPC_TOOLS%" "%PROTO_DST%\" >nul
) else (
  echo ERROR: Could not find protobuf include directory.
  echo Looked in:
  echo   %PROTO_FROM_PREFIX%
  echo   %PROTO_FROM_GRPC_TOOLS%
  exit /b 1
)

:: Build and install package
%PYTHON% -m pip install . -vv --no-build-isolation --no-deps

if errorlevel 1 exit 1

:: Necessary for the test environment and the test suite to run.
echo Freeing up disk space
rmdir /s /q %SRC_DIR%\cpp\out
echo End of freeing up disk space
