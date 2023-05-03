#!/bin/bash
# Cleanup script
# Version: 0.0.2
set -e
scripts_dir=/opt/easy-linux
compiled_dir=$HOME/compiled

if [[ ! -d "${scripts_dir}" ]]; then  
    return
elif [[ -d "${scripts_dir}" ]]; then 
    sudo rm -RF ${scripts_dir}
else 
    return
fi
if [[ ! -d "${compiled_dir}/easy-linux" ]]; then  
    return
elif [[ -d "${compiled_dir}/easy-linux" ]]; then 
    sudo rm -RF ${compiled_dir}/easy-linux
else 
    return
fi
exit 1