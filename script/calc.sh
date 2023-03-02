#!/bin/bash
all_tag=$(git tag)
Version=`echo $all_tag |rev| cut -d " " -f1 | rev`
if [ "${Version}" = "" ];then
Version="1.0.1"
else
tag_parts=(${Version//./ })
# doing the calc on arry 
((tag_parts[2]++))
Version="${tag_parts[0]}.${tag_parts[1]}.${tag_parts[2]}"
fi
echo $Version