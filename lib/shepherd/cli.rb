require "trollop"

module Shepherd	
	
	# Command Line Interface class
	# 
	# === Usage
	# 
	#     module Shepherd
	#        Cli.new.run!
	#     end
	# 
	# or
	# 
	#     Shepherd::Cli.new.run!
	# 
	# === Exit statuses
	# 
	# - *0* Everything went just fine :)
	# - *1* User said ^C :]
	# - *2* User wanted a UnknownCommand
	# - *3* The database file was not found
	# - *4* User wanted to init another sheep/project with the same name and/or path
	# - *5* User wanted to init a project in a path that doesn't exist
	# - *6* User wanted to see a sheep that was not inited
	# 
	class Cli
		
		# Kinda self explanatory
		class UnknownCommand < RuntimeError; end
		
		# A command which is about to be run
		attr_accessor :command
		
		# Require *all* command files
		# TODO: Is it possible to make it use autoload? It'd be cool! :)
		Dir[File.join(File.dirname(__FILE__), "commands", "*.rb")].each do |all_command_files|
			require all_command_files
		end
		
		# Handle the commands list
		# 
		# @return [Array] all available commands
		COMMANDS = Command.constants.select { |c| Class === Command.const_get(c) }
		
		# Get a list of available commands to be printed. (Almost) every line is separated by new line mark - \n
		# 
		# @return [String] list of all available commands
		def commands_list
			out = ""
			# If there are no commands set
			if COMMANDS.empty?
				out << "  ooops! commands are not here!"
			else
				# Get the longest command's name, so we can output it nice 'n' clean
				# This '+ int' at the end is a distance (in spaces) from the longest
				#                                            command to descriptions
				longest = COMMANDS.max_by(&:size).size + 8
				COMMANDS.each do |cmd|
					# Calc, calc.
					spaces = longest - cmd.size
					# Check if there is a 'desc' method
					desc = if eval "Command::#{cmd}.new.respond_to? 'desc'"
						# If there is - execute it
						eval "Command::#{cmd}.new.desc"
					else
						# If there is not
						"---"
					end
					out << "  " << cmd.downcase.to_s << " " * spaces << desc
					# If this command is the last one, don't make a new line
					unless cmd == COMMANDS.last
						out << "\n"
					end
				end
			end
			out
		end # commands_list:Method
		
		# Check if command really exists
		# 
		# @return [Boolean] whether the command exists or not
		def command_exists?
			COMMANDS.include? @command
		end
		
		# Rruns t'e Cli!
		def run!
			
			# Nice, cool 'n' AWESOME --options parsing with Trollop[http://trollop.rubyforge.org/]!
			# 
			# @return [Hash] array full of options
			$opts = Trollop::options do
				version "shepherd version #{Version::STRING}"
				banner <<-EOB
usage: shep [options] <command>
  
commands are:
  
#{Cli.new.commands_list}
  
  shep <command> --help/-h for more info about specified command
  
options are:  
EOB

				opt :version, "show version and exit", :short => '-v'
				opt :help, "show me and exit", :short => '-h'
				
				stop_on COMMANDS.collect { |e| e.downcase.to_s }
			end
			
			# Get the command
			@command = ARGV.shift.capitalize.to_sym
			
			begin
				execute @command
				exit 0
			rescue UnknownCommand => e
				puts e.message
				exit 2
			rescue Db::DatabaseNotFound => e
				puts e.message
				exit 3
			rescue Interrupt
				puts "\n\n!# interrupted"
				exit 1
			end
		end # run!:Method
		
		# Executes a command
		# 
		# @return [Object] command to execute
		# @raise [UnknownCommand] if there is no such a command
		def execute command
			if command_exists?
				eval "Command::#{command}.new.init"
			else
				raise UnknownCommand, "Error: unknown command '#{command.downcase.to_s}'.\nTry --help for help."
			end
		end # execute_command:Method
	end # Cli:Class
end # Shepherd:Module
