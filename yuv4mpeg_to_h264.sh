#!/bin/bash
#
# This script encodes the YUV4MPEG stream piped into it to h264
#
#  - The 1st parameter is the target file name (mandatory)
#  - The 2nd parameter is the WAV file for the sound track (mandatory)
#


BITRATE=1800

if [[ $# -ne 2 ]] ; then
	echo "1st param: <target file name>, 2nd param: <WAV file>"
	exit -2
fi

TARGET_NAME=$1
WAV_NAME=$2
PASS1_NAME=${TARGET_NAME%\.*}.pass1
LOG_NAME=${TARGET_NAME%\.*}.log

# Check that there is a pipe for this process
#
if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
	VIDEO_ENC_OPTS="-noskip -passlogfile $LOG_NAME -ovc x264 -x264encopts bitrate=${BITRATE}:subq=6:partitions=all:8x8dct:me=umh:frameref=5:bframes=3:b_pyramid:weight_b:threads=auto"
	AUDIO_ENC_OPTS="-audiofile ${WAV_NAME} -oac mp3lame -lameopts br=96:cbr"
	
	#
	# First pass
	#
	cat | mencoder - $AUDIO_ENC_OPTS -demuxer +y4m ${VIDEO_ENC_OPTS}:pass=1 -o $PASS1_NAME

	#
	# Second pass
	#
	mencoder $PASS1_NAME -oac copy ${VIDEO_ENC_OPTS}:pass=2 -o $TARGET_NAME

else
	echo "This script requires piped input!"
	exit -1
fi
