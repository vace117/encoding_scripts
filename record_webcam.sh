ffmpeg -f alsa -i default -f video4linux2 -s 800x600 -i /dev/video0 -r 24 -f avi -vcodec mpeg4 -vtag xvid -sameq -acodec libmp3lame -ab 96k `date | awk '{print $4}' | sed 's/:/_/g'`.avi
