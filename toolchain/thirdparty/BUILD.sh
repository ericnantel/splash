#!/bin/sh

os=$(uname -o)

echo 
echo +===============================+
echo + Building LibJPEG-Turbo.. ++++++
echo +===============================+
echo 

cd libjpeg-turbo
mkdir -p build
cd build
cmake ..
cmake --build . --config Release

cd ../..