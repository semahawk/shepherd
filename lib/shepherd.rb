module Shepherd
	ROOT = File.expand_path(File.dirname(__FILE__))
	
	autoload :Cli,        "#{ROOT}/shepherd/cli"
	autoload :Command,    "#{ROOT}/shepherd/command"
	autoload :Version,    "#{ROOT}/shepherd/version"
end
