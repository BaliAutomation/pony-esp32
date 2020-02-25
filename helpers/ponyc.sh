#!/bin/bash

echo ponyc called with $*

#Parameters
PONY_DOCKER_TAG="latest"
output=""
input=""

while getopts ":c:o:" opt; do
  case ${opt} in
    c ) # process option a
        echo .............$OPTARG
        input=$OPTARG
        ;;
    o ) # process option t
        echo ............----.$OPTARG
        output=$OPTARG
        ;;
    \? ) echo "Usage: cmd [-c] pony_file [-o] output_file"
      ;;
  esac
done
shift $((OPTIND -1))

if [ -z $input ]
then
	echo "Input is absent"
	exit
fi

if [ -z $output ]
then
	echo "Output is absent"
	exit
fi

#create a temporary directory
tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)

#Compile Pony source to LLVM IR
cp $input $tmp_dir
docker run -v $tmp_dir:/src/main ponylang/ponyc:$PONY_DOCKER_TAG sh -c "ponyc --pass=ir"
sed -i 's/main/pony_main/' $tmp_dir/*.ll

llfl=$(basename $(ls $tmp_dir/*.ll))
#Compile IR to object
docker run -v $tmp_dir:/src/main moharaka/llvm-esp32:latest sh -c "cd /src/main/; /llvm-esp/llc -O=0 --march=xtensa -filetype=obj $llfl"
cp $tmp_dir/*.o $output
