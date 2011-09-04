# Goes through the given srt file and increases all of the indecies by the given increament
#

if [[ $# -ne 2 ]] ; then
 echo "Usage: $0 <input srt file> <increament>"
 echo
 exit -1;
fi

gawk -v INC=$2 '{
 if ( $0 ~ /^[0-9]+\x0d?$/ ) print $0 + INC;
 else print $0
}' < "$1"
