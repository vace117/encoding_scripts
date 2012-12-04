#!/bin/sh
#
# Use this script to export Sony A57 videos from Cinelerra
#

# Change these to suite your needs
######## Canon G6 ##############
frame_rate=10
resolution=640x480
######## Sony A57 ##############
#frame_rate=59.9401
#resolution=1920x1080

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

command="x264 /tmp/cine_pipe --input-res $resolution --fps $frame_rate --bitrate $bit_rate \
    --pass $pass --stats \"$base.stats\" \
    --bframes 2 --b-adapt 2 \
    --direct auto \
    --threads auto \
    --output \"$outfile\""

# Make a named pipe
rm /tmp/cine_pipe 2> /dev/null
mkfifo /tmp/cine_pipe

echo "Running pass $pass:"
echo "     $command"
echo

# Run the encoding command. It will block and wait for y4mtoyuv to start feeding data into the pipe
eval "$command &"

# Pipe the input from Cinelerra into y4mtoyuv, which pipes its output into the named pipe
cat | y4mtoyuv > /tmp/cine_pipe

