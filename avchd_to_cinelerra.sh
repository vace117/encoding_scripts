#!/bin/bash
# 1) Convert AVCHD 1080p 60 FPS video to dnxhd which Cinelerra can read.
# 2) Extract wav from the resulting video. Cinelerra needs the sound imported separately.
# 
#

if [[ $# -lt 1 ]] ; then
    echo
    echo "  Usage: $0 <file1> <file2> ..."
    echo
    exit 1
fi

spaces() {
  echo
  echo
  echo
  echo
  echo
  echo
  echo
}


for in_file in $@ ; do
  out=${in_file%%.*}.mov
  command1="ffmpeg -i $in_file -b 185M -vcodec dnxhd -acodec pcm_s16le -threads 4 $out"
  command2="mplayer $out -vo null -vc dummy -ao pcm:file=${out%%.*}.wav"

  echo $command1
  eval $command1

  spaces

  echo $command2
  eval $command2

  spaces
done
