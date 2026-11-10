#!/bin/sh

# Currently only supports tilem2

os=$(uname -o)
starting_dir=$(cd $(dirname $0) && pwd)

filename="splash"
binaries_dir=${starting_dir}/binaries
roms_dir=${starting_dir}/roms

tilem2 -r ${roms_dir}/ti83p_v1_19/ti83plus.rom ${binaries_dir}/${filename}.8xp
