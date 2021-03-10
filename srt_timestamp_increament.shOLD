# Goes through the given srt file and increases all of the timestamps by the given increament
#
# The given timestamp must be in the following format:
#     hh:mm:ss,SS 
#

if [[ $# -lt 2 ]] ; then
 echo "Usage: $0 <input srt file> <[-]hh:mm:ss,SS> [start index]"
 echo
 exit -1;
fi

if [[ $# -eq 3 ]] ; then 
 IDX=$3
else
 IDX=0
fi

gawk -v INC=$2 -v START_IDX=$IDX '

function timestampToMilli(timestamp) {
 nFields = split(timestamp, fields, /:|,|\./);

 if ( nFields != 4 ) {
  print "Invalid timestamp format provided! The correct format is [-]hh:mm:ss,SS"
  exit;
 } 

 return fields[4] + 1000*fields[3] + 60000*fields[2] + 3600000*fields[1];
}

function milliToTimestamp(millis) {
 hh = int(millis / 3600000);
 if ( length(hh) == 1 ) hh = "0"hh; 
 
 millis = millis % 3600000;
 mm = int(millis / 60000);
 if ( length(mm) == 1 ) mm = "0"mm;

 millis = millis % 60000;
 ss = int(millis / 1000);
 if ( length(ss) == 1 ) ss = "0"ss;

 SS = millis % 1000;
 if ( length(SS) == 1 ) SS = "00"SS; 
 else if ( length(SS) == 2 ) SS = "0"SS; 

 return hh":"mm":"ss","SS;
}

BEGIN {
 if ( substr(INC, 1, 1) == "-" ) MILLISECONDS_INC = -1 * timestampToMilli(substr(INC,2));
 else MILLISECONDS_INC = timestampToMilli(INC);

 # Make sure that START_IDX is a number
 if ( (START_IDX + 0) != START_IDX ) START_IDX = 0;
}

/^[0-9]+\x0d?$/ {
 if ( $0 >= START_IDX ) SHIFT_ON = 1;
}

{
 if ( (SHIFT_ON == 1) && ($0 ~ /^[0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9]? --> /) ) {
	split($0, fromTo, " --> ");
	FROM_MILLIS = timestampToMilli(fromTo[1]);
	TO_MILLIS = timestampToMilli(fromTo[2]);

	print milliToTimestamp(FROM_MILLIS+MILLISECONDS_INC)" --> "milliToTimestamp(TO_MILLIS+MILLISECONDS_INC);
 }
 else print $0
}

' < "$1"

