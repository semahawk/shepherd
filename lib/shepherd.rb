module Shepherd
	ROOT = File.expand_path(File.dirname(__FILE__))
	
	autoload :Command,    "#{ROOT}/shepherd/command"
	autoload :Counter,    "#{ROOT}/shepherd/counter"
	autoload :Db,         "#{ROOT}/shepherd/db"
	autoload :Cli,        "#{ROOT}/shepherd/cli"
	autoload :Version,    "#{ROOT}/shepherd/version"
end
