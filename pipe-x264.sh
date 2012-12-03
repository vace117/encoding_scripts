#!/bin/sh
#
def_interlace=1
def_fast=2
def_pass=1

help(){
    cat <<END
Usage: $0 [options] filename.anything
Options:
    -i n      n=0 prog, n=1 top, n=2 bot            ($def_interlace)
    -q n      n=1 slow, n=2 fast                    ($def_fast)
    -p n      pass n                                ($def_pass)
    -h        Print this help message
END
    exit 0
}

interlace=$def_interlace
fast=$def_fast
pass=$def_pass

while getopts i:p:q:h name "$@"
do
    case $name in
i)
    interlace=$OPTARG ;;
p)
	pass=$OPTARG ;;
q)
    subq=$OPTARG ;;
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

case $interlace in
0)
    iflag_m=NOT_INTERLACED
	xint_g="--direct auto" ;;
1)
    iflag_m=INTERLACED_TOP_FIRST
	xint_g="--direct spatial --interlaced --tff" ;;
*)
	iflag_m=INTERLACED_BOTTOM_FIRST
	xint_g="--direct spatial --interlaced --bff" ;;
esac

case $rescale in
1)
	xint_f="nointerlaced" ;;
*)
	scale_f="" ;;
esac

echo "Encoding yuv4mpeg on /dev/stdin to $base.264"

case $fast in
1)
echo x264 --fps 30000/1001 --sar 4:3 --pass $pass --bitrate 10000 \
    --stats $base.stats --level 4.1 --keyint 14 --min-keyint 2 \
    --ref 3 --mixed-refs --bframes 2 --b-adapt 2 --weightb $xint_g \
    --deblock -1:-1 --subme 7 \
    --trellis 2 --partitions p8x8,b8x8,i4x4,i8x8 --8x8dct \
    --ipratio 1.1 --pbratio 1.1 \
    --vbv-bufsize 14475 --vbv-maxrate 17500 --qcomp 0.5 \
    --me umh --threads auto \
    --output $outfile /dev/stdin 1440x1080 \
    --mvrange 511 --aud

y4mtoyuv |
x264 --fps 30000/1001 --sar 4:3 --pass $pass --bitrate 10000 \
    --stats $base.stats --level 4.1 --keyint 14 --min-keyint 2 \
    --ref 3 --mixed-refs --bframes 2 --b-adapt 2 --weightb $xint_g \
    --deblock -1:-1 --subme 7 \
    --trellis 2 --partitions p8x8,b8x8,i4x4,i8x8 --8x8dct \
    --ipratio 1.1 --pbratio 1.1 \
    --vbv-bufsize 14475 --vbv-maxrate 17500 --qcomp 0.5 \
    --me umh --threads auto \
    --output $outfile /dev/stdin 1440x1080 \
    --mvrange 511 --aud ;;
*)
echo x264 --fps 30000/1001 --sar 4:3 --pass $pass --bitrate 10000 \
	--stats $base.stats --level 4.1 --keyint 14 --min-keyint 2 \
	--ref 2 --mixed-refs --bframes 2 --weightb $xint_g \
	--deblock -1:-1 --subme 5 \
	--partitions p8x8,b8x8,i4x4,i8x8 --8x8dct \
	--ipratio 1.1 --pbratio 1.1 \
	--vbv-bufsize 14475 --vbv-maxrate 17500 --qcomp 0.5 \
	--merange 12 --threads auto \
	--output $outfile /dev/stdin 1440x1080 \
	--mvrange 511 --aud

y4mtoyuv |
x264 --fps 30000/1001 --sar 4:3 --pass $pass --bitrate 10000 \
	--stats $base.stats --level 4.1 --keyint 14 --min-keyint 2 \
	--ref 2 --mixed-refs --bframes 2 --weightb $xint_g \
	--deblock -1:-1 --subme 5 \
	--partitions p8x8,b8x8,i4x4,i8x8 --8x8dct \
	--ipratio 1.1 --pbratio 1.1 \
	--vbv-bufsize 14475 --vbv-maxrate 17500 --qcomp 0.5 \
	--merange 12 --threads auto \
	--output $outfile /dev/stdin 1440x1080 \
	--mvrange 511 --aud ;;
esac
