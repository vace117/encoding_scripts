#!/bin/bash

usage() {
    echo "Usage: srt_timestamp_increament.sh <offset seconds> <input_file.srt>"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

OFFSET=$1
INPUT=$2
OUTPUT=${INPUT%.*}_SHIFTED.srt

COMMAND="ffmpeg -itsoffset $OFFSET -i '$INPUT' -c copy '$OUTPUT'"

printf "\n\n\n    $COMMAND\n\n\n"
eval $COMMAND