module Shepherd
	module Utils
		def yes? msg = "Would you like to proceed?"
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
		
		# Convert bytes into more human readable format.
		# I have found nice resolution here[http://www.ruby-forum.com/topic/119703]
		#  which was originally written by Jeff Emminger and I just add this part
		#  to automaticly set the unit. Thank you, Jeff!
		# 
		# @param [Integer] number of bytes to be formatted
		# @return [String] a formatted number with the unit appended to it
		def self.nice_bytes number
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
	end
end

class Integer
	def to_nice
		s = self.to_s

		if s.include? ?.
			pre, post = s.split '.'
			"#{pre.reverse.gsub( /\d{3}(?=\d)/, '\&,' ).reverse}.#{post}"
		else
			s.reverse.gsub( /\d{3}(?=\d)/, '\&.' ).reverse
		end
	end
end
