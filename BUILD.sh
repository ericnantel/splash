#!/bin/sh

#Prerequisites
#TASM.EXE is a 32bit Windows Application (.exe)
#So it can run fine on Windows 11 with a x86_64 cpu arch
#On Mac or Linux -> install wine or similar application to run TASM.EXE
#First time you run wine, it may ask for permissions
#DEVPAC8X.COM is a 16bit DOS Application (.com)
#It can run on Windows 98
#On Modern PC, either use an emulator such as Virtual Box or UTM
#Or install DOSBox (recommended) on Windows 11, Mac or Linux
#First time you run DOSBox, it may ask for permissions

#brew tap homebrew/cask-versions
#brew install --cask --no-quarantine wine-stable

os=$(uname -o)
starting_directory=$(cd $(dirname $0) && pwd)
directory="ti83plus"
filename="splash"
include_file="ti83plus.inc"
source_file=${filename}.z80.asm
binary_file=${filename}.bin
listing_file=${filename}.lst
export_file=${filename}.8xp

echo assemble..

#ASSEMBLE
cd ${directory}
cp ${include_file} ..
cp ${source_file} ..
cd ..
mv ${include_file} toolchain/tasm
mv ${source_file} toolchain/tasm
cd toolchain/tasm
#if not exist TASM.EXE goto missing_assembler
wine TASM.EXE -80 -i -b ${source_file} ${binary_file}

echo preparing..

#PREPARE
mv ${include_file} ../cache
mv ${source_file} ../cache
#if not exist ${binary_file} goto fail_assemble
cp ${binary_file} ../cache
mv ${binary_file} ../devpac8x
#if not exist ${listing_file} goto fail_assemble
cp ${listing_file} ../cache
mv ${listing_file} ../devpac8x

echo export..

#EXPORT
cd ..
cd devpac8x
#if not exist DEVPAC8X.COM goto missing_exporter
dosbox_path="/Applications/DOSBox.app/Contents/MacOS/DOSBox"
${dosbox_path} -c "MOUNT C $(pwd)" -c "C:" -c "DEVPAC8X ${filename}" -c "exit"
#if not exist ${export_file} goto fail_export
rm ${binary_file}
rm ${listing_file}
cp ${export_file} ../cache
mv ${export_file} ..
cd ..
mv ${export_file} ../binaries
cd ..

#TODO RUN OR TRANSFER

echo Success

cd ${starting_directory}


