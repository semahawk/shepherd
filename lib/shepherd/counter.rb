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
			@files.size
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
		def bytes
			@bytes = 0
			@files.each do |file|
				@bytes += File.new("#{file}").size
			end
			@bytes
		end
	end
end
