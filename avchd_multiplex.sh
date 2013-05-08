#!/bin/bash
# Multiplex video and sound
#

if [[ $# -lt 2 ]] ; then
    echo
    echo "  Usage: $0 <video file> <sound file>"
    echo
    exit 1
fi

command="ffmpeg -i $1 -i $2 -acodec libmp3lame -ab 128k -ar 48000 -vcodec copy ${1%%.*}.avi"

echo $command
eval $command
