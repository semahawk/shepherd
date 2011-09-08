module Shepherd
	ROOT = File.expand_path(File.dirname(__FILE__))
	
	autoload :Utils,      "#{ROOT}/shepherd/utils"
	autoload :Setup,      "#{ROOT}/shepherd/setup"
	autoload :Command,    "#{ROOT}/shepherd/command"
	autoload :Counter,    "#{ROOT}/shepherd/counter"
	autoload :Db,         "#{ROOT}/shepherd/db"
	autoload :Cli,        "#{ROOT}/shepherd/cli"
	autoload :Version,    "#{ROOT}/shepherd/version"
	
	# Stay DRY
	extend Utils
	
	# Check if the setup was once done
	if !Dir.exists? "#{Dir.home}/.shepherd"
		# Setup was not done so we'll do it, but...
		sleep 0.5
		puts "Hello there!"
		sleep 2 
		puts "It's your first time using Shepherd, isn't it?"
		sleep 4
		puts "Knew it!"
		sleep 1.5
		puts "But before the first run, we would have to make some setup first..."
		sleep 4.5
		puts "Do you know who's the cousin of zebra?"
		sleep 3
		puts "You don't?? Phew.."
		sleep 2
		puts "Ghehe, I know, but I won't tell you.."
		sleep 2.8
		puts "Oh, no, the setup is *not* running now..."
		sleep 2
		puts "Okey, okey! Calm down and don't yell at me.."
		sleep 3
		puts "All right, as you wish, I am doing the setup. You have 10.."
		sleep 3.7
		puts "No, 5 seconds to abort."
		sleep 2
		print "5"; sleep 0.4; print "."; sleep 0.4; print "."; sleep 0.2; print " "
		print "4"; sleep 0.4; print "."; sleep 0.4; print "."; sleep 0.2; print " "
		print "3"; sleep 0.1; print "."; sleep 0.1; print "."; sleep 0.1; print " "
		puts "Too late!"
		sleep 10
		puts "Oh my gosh.. I forgot to click this big, red button which says 'Stop annoying people and do the setup'. Sorry.."
		sleep 6.5
		puts "Well, I suppose you actually are a human.."
		sleep 4
		puts "Okey, okey!\n\n"
		sleep 2.2
		puts "*click*\n\n"
		sleep 0.5
		# Ghehe :)
		Setup.new
	end
end
