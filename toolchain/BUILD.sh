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

echo 
echo +===============================+
echo + Testing Jpeg2Bin.. ++++++++++++
echo +===============================+
echo 

if [[ "$os" == 'Msys' ]]; then
	./bin/Debug/jpeg2bin.exe
else
	./bin/jpeg2bin
fi

cd ../..