#!/bin/sh

os=$(uname -o)
starting_dir=$(cd $(dirname $0) && pwd)

project_dir="splash"
filename="splash"
calcname="SPLASH" #MUST BE UPPERCASE AND LESS THAN 8 CHARACTERS
tmp_dir=${starting_dir}/tmp/${filename}
binaries_dir=${starting_dir}/binaries
assembler_dir=${starting_dir}/toolchain/tasm
packer_dir=${starting_dir}/toolchain/binpac8x

echo copying .z80.asm
mkdir -p ${tmp_dir}
cp ${assembler_dir}/TASM.EXE ${tmp_dir}
cp ${assembler_dir}/TASM80.TAB ${tmp_dir}
cp -rp ${project_dir}/* ${tmp_dir}

echo assembling .bin
cd ${tmp_dir}
tasm_params="-80 -i -b ${filename}.code.z80.asm ${filename}.bin"
if [ "$os" = 'Msys' ]; then
	./TASM.EXE ${tasm_params}
elif [ "$os" = 'GNU/Linux' ]; then
	wine32 TASM.EXE ${tasm_params}
else
	wine TASM.EXE ${tasm_params}
fi

echo copying .bin
mkdir -p ${binaries_dir}
cp ${filename}.bin ${binaries_dir}/${filename}.bin
cd ${starting_dir}

echo exporting .8xp
python3 ${packer_dir}/binpac8x.py -O ${calcname} ${binaries_dir}/${filename}.bin

echo done.
