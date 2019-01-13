#!/bin/bash

usage() {
	echo "Usage: download_youtube.sh <URL> [--quality|-q 1080/720/...etc>] [<URL>]"
	exit 1
}

consume_arguments() {
	while [[ $# -gt 0 ]]; do
	case $1 in
	    -q|--quality)
		    QUALITY="$2"
		    shift # consume argument
		    shift # consume value
	    ;;

		http*)    # URL Parameter
		    URLs="$URLs $1"
		    shift # consume argument
    	;;

		*)    # unknown option
			echo "Error: Unknown option $1"
			exit 2
    	;;

	esac
	done

	if [[ -z $URLs ]]; then
	    usage
	fi

}


QUALITY=720

consume_arguments $*

echo "Downloading $URLs at ${QUALITY}p..."

youtube-dl \
 --no-playlist \
 -f "bestvideo[height<=$QUALITY][ext=mp4]+bestaudio[ext=m4a]" \
 --merge-output-format mp4 \
 $URLs
