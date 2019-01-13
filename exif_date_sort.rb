#!/usr/bin/ruby
# Copies all JPEG files under the given directory to another location. The files are renamed
# so that the new file names contain the timestamp obtained from the EXIF data in the image.
# JPEGs with no EXIF data are not processed at all
#
# This script is useful for arranging pictures from multiple cameras in chronological order 
# (assuming the date on the cameras was synchronized)
#
# The script will look for directories named '.../.../person_<name>/...' in order to append
# the person's name to the resulting file name. This allows you to keep track of whose camera
# the pictures are from even after the merge
#

require "rubygems"
require "find"
require "exifr"
require "set"
require "ftools"
require "fileutils"

raise "Usage: #{$0.split(File::SEPARATOR).last} <input_dir> <out_dir>" unless ARGV.size == 2

# This set is used to keep track of file names that were already used. This will
# catch images with identical date stamps and make sure that the resulting image is not
# overwritten
usedFileNames = Set.new

in_dir = File.expand_path(ARGV[0])
out_dir = File.expand_path(ARGV[1])
begin
	Dir.mkdir(out_dir)
rescue SystemCallError
	# Swallow the exception (happens if dir already exists)
end

puts "Scanning #{in_dir} ....\n"

Find.find(in_dir) do |path|
 if ( File.basename(path) =~ /.jpg$/i ) then # Make sure that we only work with JPEGS
	dateTime = EXIFR::JPEG.new(path).date_time_original
	if ( dateTime != nil ) then
		# Format all fields to use two digits (i.e. append leading 0 if necessary)
		month = "%02d" % dateTime.month 
		day = "%02d" % dateTime.day
		hour = "%02d" % dateTime.hour
		minute = "%02d" % dateTime.min
		second = "%02d" % dateTime.sec
		
		# Figure out the file name, watching out for cases where the date stamp is identical for some images
		#
		newFileName = "DS_#{dateTime.year}#{month}#{day}_#{hour}#{minute}#{second}"
		while usedFileNames.include?(newFileName) do
			newFileName = newFileName + "_dup"
		end
		usedFileNames.add( newFileName )

		# Append the name of the person, if there is a folder named '..../person_.../...' in the path
		#
		temp = path.split('person_')
		if ( temp.length == 2 ) then
			person_name = temp[1].split('/')[0]
			newFileName = newFileName + "_" + person_name
		end

		# Copy the resulting file into the target directory
		# 
		finalNewFileName = "#{out_dir}#{File::SEPARATOR}#{newFileName}.jpg"
		puts "#{File.basename(path)} --> #{finalNewFileName}"
		FileUtils.copy(path, finalNewFileName)
	else
		puts "#{path} has no EXIF data. Cannot process."
	end
 end
end
