#!/bin/bash
#
# Use this script to export Sony A57 videos from Cinelerra
#

# Change these to suite your needs
######## Canon G6 ##############
#frame_rate=10
#resolution=640x480
######## Sony A57 ##############
frame_rate=59.9401
resolution=1920x1080


#frame_rate=2
#resolution=960x720


################### WARNING!!!! Automation is broken. Scroll down and modify ffmpeg command manually!




pass=1
bit_rate=10000

help(){
    cat <<END
Usage: $0 [options] filename.anything
Options:
    -b n      bitrate n                             ($bit_rate)
    -p n      pass n                                ($pass)
    -h        Print this help message
END
    exit 0
}

while getopts b:p:h name "$@"
do
    case $name in
b)
	bit_rate=$OPTARG ;;
p)
	pass=$OPTARG ;;
*)
    help ;;
    esac
done
let shiftind=$OPTIND-1
shift $shiftind
if test "$#" != "1"
then
    help
fi

outfile=$1
base=`echo $outfile | sed "s/\.[^.]*$//"`

#command="x264 /tmp/cine_pipe --input-res $resolution --fps $frame_rate --bitrate $bit_rate \
#    --pass $pass --stats \"$base.stats\" \
#    --bframes 2 --b-adapt 2 \
#    --direct auto \
#    --threads auto \
#    --output \"$outfile\""

#command="ffmpeg -y -i /tmp/cine_pipe -b 1500k -f mp4 -vcodec libx264 -pass 1 -vpre medium_firstpass -r 25 -aspect 16:9 -s 854x480 -an  \"$outfile\""
#command="ffmpeg -y -i /tmp/cine_pipe -b 1500k -f mp4 -vcodec libx264 -pass 2 -vpre medium -r 25 -aspect 16:9 -s 854x480 -an  \"$outfile\""
#command="ffmpeg -y -threads 8 -i /tmp/cine_pipe -f mp4 -vcodec libx264 -preset slow -crf 17 -r 25 -aspect 16:9 -s 640x360 -an  \"$outfile\""
command="ffmpeg -y -threads 8 -i /tmp/cine_pipe -f mp4 -vcodec libx264 -preset slow -crf 10 -r 25 -aspect 16:9 -s 1280x720 -an  \"$outfile\""
#command="ffmpeg -y -threads 8 -i /tmp/cine_pipe -f mp4 -vf "transpose=2" -vcodec libx264 -preset slow -crf 25 -r 25 -aspect 9:16 -s 540x960 -an  \"$outfile\""

# Make a named pipe
rm /tmp/cine_pipe 2> /dev/null
mkfifo /tmp/cine_pipe

echo "Running pass $pass:"
echo "     $command"
echo

# Run the encoding command. It will block and wait for cat to start feeding data into the pipe
eval "$command &"

cat > /tmp/cine_pipe
#cat | y4mtoyuv > /tmp/cine_pipe
