module Shepherd
	ROOT = File.expand_path(File.dirname(__FILE__))
	
	autoload :Setup,      "#{ROOT}/shepherd/setup"
	autoload :Command,    "#{ROOT}/shepherd/command"
	autoload :Counter,    "#{ROOT}/shepherd/counter"
	autoload :Db,         "#{ROOT}/shepherd/db"
	autoload :Cli,        "#{ROOT}/shepherd/cli"
	autoload :Version,    "#{ROOT}/shepherd/version"
	
	# Checking if the setup was once done
	if File.exists? "#{Dir.home}/.shepherd/setup.yml"
		require "yaml"
		yml = YAML::load(File.open("#{Dir.home}/.shepherd/setup.yml"))
		if yml
			Setup.make :force => true unless yml['status'] == "done"
		else
			
			Setup.make :force => true
		end
	else
		# Setup was not done, so just do it
		Setup.make #if Utils.yes? "~> setup was not done yet - do it now?"
	end
end
