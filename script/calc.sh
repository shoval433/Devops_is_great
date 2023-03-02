#!/bin/bash
all_tag=$(git tag)
Version=`echo $all_tag |rev| cut -d " " -f1 | rev`
echo "!!!!!!!!!!!!!!!"
echo ${Version}
echo "!!!!!!!!!!!!!!!"
if [ "${Version}" = "" ];then
Version="1.0.1"
else
tag_parts=(${Version//./ })
# doing the calc on arry 
((tag_parts[2]++))
Version="${tag_parts[0]}.${tag_parts[1]}.${tag_parts[2]}"
fi

# # check the res
# Version_Test=$(echo $Version | cut -d '.' -f1-2)
# if [ "${Version_Test}" != "$1" ];then
# Version="$1.1"
# fi

echo $Version