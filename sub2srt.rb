#!/usr/bin/ruby
#
# Converts a .sub file to .srt format
#

subFileName = ARGV[0]
subFile = File.open(subFileName, "r")

index = 0

begin
    while (line = subFile.readline) 
		unless line =~ /^\[.*\]/ # Exclude meta data lines
			if line =~ /[0-9][0-9]:[0-9][0-9]:[0-9][0-9].*,[0-9][0-9]:[0-9][0-9]:[0-9][0-9]/
				puts index += 1

				times = line.split(',')
				puts times[0] + " --> " + times[1]
			else
				puts line.gsub(/\[br\]/, "\n")
			end
		end
    end
rescue EOFError
    subFile.close
end
