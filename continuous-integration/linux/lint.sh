#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR=$(realpath "$SCRIPT_DIR/../..")
SOURCE_DIR="$ROOT_DIR/source"

cppFiles=$(find "$SOURCE_DIR" -name '*.cpp')
hFiles=$(find "$SOURCE_DIR" -name '*.h')

if [ -z "$cppFiles" ]; then
    echo Error: Cannot find C++ source files
    exit 1
fi

echo "Checking formatting"
errorsFound=0
for fileName in $cppFiles $hFiles; do
    echo $fileName
    diff $fileName <(clang-format-8 $fileName)
    if [ $? -ne 0 ]; then
        let "errorsFound=errorsFound+1"
    else
        echo "ok"
    fi
done
echo
if [ $errorsFound -ne 0 ]; then
    echo "ERROR: $errorsFound formatting error(s) found! See the diffs for each file printed above."
    exit 1
fi
echo "All files are properly formatted!" ["$0"]

BUILD_DIR="$ROOT_DIR/build/ci/tidy"
mkdir --parents "$BUILD_DIR" || exit $?
cd "$BUILD_DIR" || exit $?
cmake -GNinja \
    -DUSE_EIGEN3=OFF \
    -DUSE_OPENCV=OFF \
    -DCMAKE_CXX_CLANG_TIDY="/usr/bin/clang-tidy-8" \
    -DWARNINGS=ON \
    -DWARNINGS_AS_ERRORS=ON \
    ../../.. || exit $?
cmake --build . || exit $?
