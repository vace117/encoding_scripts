#
# Takes an m3u file and renames specified files so that their natural order corresponds to the order in the m3u.
# This is done by appending a numerical index at the beginning of the file name.
# 
exit 1 if ARGV.length != 1

m3u_file = ARGV[0]

exit 2 unless m3u_file.end_with? "m3u"

puts "Renaming files to reflect the order specified in #{m3u_file}...."

count = 0
File.open(m3u_file, "r") do |m3u|
  while (line = m3u.gets) 
    if (not line.start_with? "#") 
      prefix = "%03d" % count+=1
      line = line.chomp

      new_file_name = "#{prefix}_#{line}"
      puts new_file_name
      
      File.rename(line, new_file_name)
    end
  end 
end
