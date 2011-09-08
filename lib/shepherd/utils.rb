module Shepherd
	module Utils
		def yes? msg
			print "#{msg} [Yn]: "
			case $stdin.gets
			when /(y|yes)/i
				true
			when "\n"
				true
			when /(n|no)/i
				false
			else
				false
			end
		end # yes?:Method
	end
end
