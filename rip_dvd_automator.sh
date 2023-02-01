#!/bin/bash
#
# This utility is useful for ripping a DVD when you want to automate the process and group multiple chapters
# into the same file
#

# Input and output settings
dvd_device="/dev/dvd"
track_number=1
output_directory="."

# Get the number of chapters in the track
chapter_count=$(\
    mplayer -dvd-device "$dvd_device" dvd://$track_number \
    -chapter 0-100 \
    -identify \
    -frames 0 -vo null -ao null 2>/dev/null \
    | grep ID_CHAPTERS \
    | cut -d= -f2\
)

# Loop through the chapters in pairs and rip each pair into a single file
#
for ((i=2; i<=$chapter_count; i+=2)); do
    # Set the start and end chapters for this pair
    start_chapter=$i
    end_chapter=$((i+1))

    # Create the output file name
    output_file="$output_directory/track_$track_number-chapters_$start_chapter-$end_chapter.mkv"

    # Use HandBrakeCLI to rip the chapter pair
    HandBrakeCLI \
        --input "$dvd_device" \
        --title $track_number \
        --chapters $start_chapter-$end_chapter \
        --encoder x264 \
        --aencoder mp3 \
        --output "$output_file"
done
