IN=$1
OUT=${1%.*}.mov
ffmpeg -i $IN -b 185M -vcodec dnxhd -acodec pcm_s16le -threads 4 $OUT
