#!/bin/sh

os=$(uname -o)

echo 
echo +===============================+
echo + Building Jpeg2Bin.. +++++++++++
echo +===============================+
echo 

cd jpeg2bin
mkdir -p build
cd build
cmake ..
cmake --build . --config Debug

cd ../..