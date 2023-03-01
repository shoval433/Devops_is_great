#!/bin/bash
Version=$(git describe --tags | cut -d '-' -f1 )

tag_parts=(${Version//./ })

# doing the calc on arry 
((tag_parts[2]++))
Version="${tag_parts[0]}.${tag_parts[1]}.${tag_parts[2]}"

if [ "${Version}" = "" ];then
Version="1.0.1"
fi
# # check the res
# Version_Test=$(echo $Version | cut -d '.' -f1-2)
# if [ "${Version_Test}" != "$1" ];then
# Version="$1.1"
# fi

echo $Version