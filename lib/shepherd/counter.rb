require "find"

module Shepherd
	
	# A simple class that counts all the needed data (like files, lines, bytes and so-on) in given destination path.
	# 
	# == Usage
	# 
	# Without using a block:
	#     module Shepherd
	#        count = Counter.new(/path/to/destination/dir)
	#        count.files #=> 26
	#        count.lines #=> 2319
	#        count.chars #=> 79240
	#     end
	# 
	# With a block:
	#     module Shepherd
	#        Counter.new(/path/to/destination/dir) do |count|
	#           count.files #=> 26
	#           count.lines #=> 2319
	#           count.chars #=> 79240
	#        end
	#     end
	# 
	# Inside a +Shepherd::Command::Klass+ you should use it like so:
	#     module Shepherd::Command
	#        class Klass
	#           Shepherd::Counter.new(/path/to/destination/dir) do |count|
	#              count.files #=> 26
	#              count.lines #=> 2319
	#              count.chars #=> 79240
	#           end
	#        end
	#     end
	# 
	# @return [Shepherd::Counter] a new instance of +Shepherd::Counter+
	# @yield [Shepherd::Counter] a new instance of +Shepherd::Counter+
	# 
	class Counter
		# A new instance of +Shepherd::Counter+
		# 
		# @param [String] path a path to the project
		# @return [Shepherd::Counter] a new instance of +Shepherd::Counter+
		# @yield [Shepherd::Counter] a new instance of +Shepherd::Counter+
		def initialize path
			# delete the last '/' in path if present, just to make sure :)
			@path = path.chomp "/"
			
			yield self if block_given?
		end
		
		# Convert bytes into more human readable format.
		# Found nice resolution here[http://www.ruby-forum.com/topic/119703] which was originally written by {Jeff Emminger}[http://www.ruby-forum.com/user/show/jemminger] and I just add this part to automaticly set the unit. Thank you!
		# 
		# @param [Integer] number a number to be formatted
		# @return [String] a formatted number
		def nice_bytes number
			units = {:b => 1,
						:kb => 2**10,
						:mb => 2**20,
						:gb => 2**30,
						:tb => 2**40}
			
			unit = :b
			case number
				when 1...2**10
					unit = :b
				when 2**10...2**20
					unit = :kb
				when 2**20...2**30
					unit = :mb
				when 2**30...2**40
					unit = :gb
				when 2**40...2**50
					unit = :tb
			end
			"#{sprintf("%.#{0}f", number / units[unit.to_s.downcase.to_sym])} #{unit.to_s.upcase}"
		end
		
		# Count the files (excluding dotfiles).
		# 
		# @return [Array] list of all files (dotfiles are not included)
		def files
			@files = []
			Find.find(@path) do |path|
				if File.directory? path
					if File.basename(path)[0] == ?.
						Find.prune # don't look any further into this directory.
					else
						next
					end
				else
					@files << path
				end
			end
			@files
		end
		
		# Count the lines.
		# 
		# @return [Integer] lines amount
		def lines
			@lines = 0
			@files.each do |file|
				@lines += `cat '#{file}' | wc -l`.to_i
			end
			@lines
		end
		
		# Count the characters.
		# 
		# @return [Integer] characters amount
		def chars
			@chars = 0
			@files.each do |file|
				@chars += `cat '#{file}' | wc -m`.to_i
			end
			@chars
		end
		
		# Count the bytes. This *wont* be converted all the time.
		# 
		# @return [Integer] bytes amount
		def rawbytes
			@rawbytes = 0
			@files.each do |file|
				@rawbytes += File.new("#{file}").size
			end
			@rawbytes
		end
		
		# Count the bytes. This *will* be formatted into something like: 2898 KB
		# 
		# @return [String] formatted bytes
		def bytes
			@bytes = nice_bytes rawbytes
		end
	end
end
