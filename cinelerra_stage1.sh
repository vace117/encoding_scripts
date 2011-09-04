#!/bin/bash
# Converts resolution, framerate and audio rate to the given values in all AVIs under given directory. 
# This is stage 1 of the Cinelerra import prep. Use cinelarra_stage2.sh after this
#

if [[ $# -lt 3 ]] ; then
  echo
  echo "  Usage: $0 <dir> <width>x<height> <fps>"
  echo
  exit 1
fi

WD=$1
RESOLUTION=$2
FRATE=$3
ARATE='44100'
STAGE1_FILE_NAME="stage1.sh"
rm $STAGE1_FILE_NAME 2>/dev/null

IFS=$'\n'

if [[ -d $WD ]] ; then
 cd $WD
 for i in `find . -iname "*avi"` ; do
	   echo $i
   echo $i | grep -v _ff
   echo $?
   if [[ $? -eq 0 ]] ; then


	   # Do we need to convert the resoultion?
	   S_RES=`tcprobe -i $i 2>/dev/null | grep 'frame size' | awk '{print $5}'`
	   CONVERT_RES="n"
	   if [[ $S_RES != $RESOLUTION ]] ; then
		CONVERT_RES="y"
		echo "   - Resolution conversion required. ($S_RES -> $RESOLUTION)"
	   fi

	   # Do we need to convert the frame rate?
	   RATE=`tcprobe -i $i 2>/dev/null | grep 'frame rate' | awk '{print $4}'`
	   S_FRATE=${RATE%.*}
	   CONVERT_FRATE="n"
	   if [[ $S_FRATE != $FRATE ]] ; then
		CONVERT_FRATE="y"
		echo "   - Frame rate conversion required. ($S_FRATE -> $FRATE)"
	   fi

	   # Do we need to convert the audio rate?
	   RATE=`tcprobe -i $i 2>/dev/null | grep 'audio track' | awk '{print $7}'`
	   S_ARATE=${RATE%%,*}
	   CONVERT_ARATE="n"
	   if [[ $S_ARATE != $ARATE ]] ; then
		CONVERT_ARATE="y"
		echo "   - Audio rate conversion required. ($S_ARATE -> $ARATE)"
	   fi

	   # Convert the necessary stuff
	   VIDEO_OPTS=""
	   if [[ $CONVERT_RES == "y" ]] ; then 
	     VIDEO_OPTS=" -s $RESOLUTION"
	   fi
	   if [[ $CONVERT_FRATE == "y" ]] ; then 
	     VIDEO_OPTS="$VIDEO_OPTS -r $FRATE"
	   fi
	   if [[ -n $VIDEO_OPTS ]] ; then 
	     VIDEO_OPTS="$VIDEO_OPTS -vcodec mjpeg"
	   else
	     VIDEO_OPTS="-vcodec copy"
	   fi
	   if [[ $CONVERT_ARATE == "y" ]] ; then 
	     AUDIO_OPTS="-ar $ARATE -acodec pcm_u8"
	   else
	     AUDIO_OPTS="-acodec copy"
	   fi

	   CMD="ffmpeg -i $i $VIDEO_OPTS $AUDIO_OPTS ${i%.*}_ff.avi"
	   echo $CMD >> $STAGE1_FILE_NAME
   fi 
 done

 echo
 echo
 cat $STAGE1_FILE_NAME 2>/dev/null
else
 echo "No such directory!"
fi
