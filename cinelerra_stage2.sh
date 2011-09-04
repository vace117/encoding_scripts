#!/bin/bash
# Uses the files from cinelarra_stage1.sh to generate final Cinelerra imports.
#

if [[ $# -lt 1 ]] ; then
  echo
  echo "  Usage: $0 <dir> "
  echo
  exit 1
fi

WD=$1
STAGE2_FILE_NAME="stage2.sh"
rm $STAGE2_FILE_NAME 2>/dev/null

IFS=$'\n'

if [[ -d $WD ]] ; then
 cd $WD
 for i in `find . -iname "*ff.avi"` ; do
	echo $i
#	CMD="mencoder $i -oac mp3lame -ovc lavc -vf harddup -lameopts abr:q=5 -lavcopts vcodec=mjpeg -ffourcc MJPG -o ${i%_ff*}_done.avi"
	CMD="mencoder $i -oac mp3lame -ovc copy -o ${i%_ff*}_done.avi"
	echo $CMD >> $STAGE2_FILE_NAME
 done

 echo
 echo
 cat $STAGE2_FILE_NAME 2>/dev/null
else
 echo "No such directory!"
fi
