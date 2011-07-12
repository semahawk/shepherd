module Shepherd

	# A (actually, very) simple class, which is used to determine whether is this class a command, or not.
	# 
	# == Creating a command
	# A Shepherd's command is just a class, which is kept inside +Shepherd::Command+.
	# Just create a ruby file inside +lib/shepherd/commands/+ called however you like, eg. foo.rb.
	# This file should look kinda like this stuff:
	# 
	#     module Shepherd::Command
	#        class Foobar # this is the commands name; that would be: shep foobar 
	#           def init # when you call: shep <command>, init method here is executed.
	#              puts "foobarinize!"
	#           end
	#        end
	#     end
	# 
	# You can also specify some other method than +init+ (eg. ahoy) and then use an +alias+ method:
	# 
	#     module Shepherd::Command
	#        class Pirate
	#           def ahoy
	#              puts "Ahoy, aad'enturre!"
	#           end
	#           alias :init :ahoy
	#        end
	#     end
	# 
	# == Options parsing
	# For --options parsing, Shepherd uses Trollop[http://trollop.rubyforge.org/] (which by the way is AWESOME!):
	# 
	#     module Shepherd::Command
	#        class Foobar
	#           def init
	#              opts = Trollop::options do
	#                 opt :monkey, "Use monkey mode"                      # flag --monkey, default false
	#                 opt :goat, "Use goat mode", :default => true        # flag --goat, default true
	#                 opt :num_limbs, "Number of limbs", :default => 4    # integer --num-limbs <i>, default to 4
	#                 opt :num_thumbs, "Number of thumbs", :type => :int  # integer --num-thumbs <i>, default nil
	#              end
	#           end
	#        end
	#     end
	# 
	# You can of course use for example +OptionParser+, if you want. But.. Trollop[http://trollop.rubyforge.org/] is AWESOME! THAT's why wise Shepherd is using it ;)
	# 
	# == Multiple commands 
	# Also, yau can create more than one command inside one file:
	# 
	#     module Shepherd::Command
	#        class Foobar 
	#           def init
	#              puts "foobarinize!"
	#           end
	#        end
	# 
	#        class Barbaz 
	#           def init
	#              puts "barbazinize!"
	#           end
	#        end
	#     end  
	# 
	module Command; end
end
