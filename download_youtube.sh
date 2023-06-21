#!/bin/bash
#
# Install this utility:
#   https://github.com/ytdl-org/youtube-dl#installation
#
# Keep it up to date with:
#	sudo youtube-dl -U
#

usage() {
	echo "Usage: download_youtube.sh <URL> [--quality|-q 1080/720/...etc>] [--audio|-a] [--output-file-name|-o] [<URL>]"
	exit 1
}

consume_arguments() {
	while [[ $# -gt 0 ]]; do
		case $1 in
		-q | --quality)
			QUALITY="$2"
			shift # consume argument
			shift # consume value
			;;

		-a | --audio)
			AUDIO_ONLY="$1"
			shift # consume argument
			;;

		-o | --output-file-name)
			FILE_NAME="$2"
			shift # consume argument
			shift # consume value
			;;

		http*) # URL Parameter
			URLs="$URLs $1"
			shift # consume argument
			;;

		*) # unknown option
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

consume_arguments "$@"

DOWNLOAD_COMMAND='youtube-dl --no-playlist'

if [[ -n $FILE_NAME ]]; then
	DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND} -o '${FILE_NAME}.%(ext)s'"
fi

if [[ -z $AUDIO_ONLY ]]; then
	echo "Downloading video from $URLs at ${QUALITY}p..."

	DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND} \
-f 'bestvideo[height<=${QUALITY}][ext=mp4]+bestaudio[ext=m4a]' \
--merge-output-format mp4 \
${URLs}"

else
	echo "Downloading audio from $URLs..."

	DOWNLOAD_COMMAND="${DOWNLOAD_COMMAND} \
-f 'bestaudio[ext=m4a]/bestaudio' \
${URLs}"

fi

echo "Executing:"
echo "    $DOWNLOAD_COMMAND"
echo 
echo 
echo "Available Formats:"
youtube-dl -F $URLs
echo 

eval $DOWNLOAD_COMMAND