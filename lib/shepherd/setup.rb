module Shepherd
	module Setup
		def self.make opts = {}
			if opts[:force]
				puts "setup --force"
			else
				puts "setup"
			end
			exit 0
		end
	end
end
