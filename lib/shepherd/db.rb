require "sqlite3"

module Shepherd
	
	# A class through which you can connect to the database.
	# 
	# == Usage
	# 
	#     module Shepherd
	#        Db.new.execute "sql query"
	#     end
	# 
	# Inside a +Shepherd::Command::Klass+, it would look like:
	# 
	#     module Shepherd::Command
	#        class Klass
	#           def init
	#              Shepherd::Db.new.execute "sql query"
	#           end
	#        end
	#     end
	# 
	# Here is {SQLite3 documantation}[http://sqlite-ruby.rubyforge.org/sqlite3/faq.html]. +Shepherd::Db.new+ is equal to +SQLite3::Database.new+ so there you've got a complete documentation.
	# 
	class Db
		
		# When the database file was not found
		class DatabaseNotFound < RuntimeError; end
		
		def initialize
			raise DatabaseNotFound, "Error: database file not found: '#{Dir.home}/.shepherd/herd.db'\nTry running 'shep setup'." unless File.exists? "#{Dir.home}/.shepherd/herd.db"
			# A new instance of +SQLite3::Database+
			@db = SQLite3::Database.new "#{Dir.home}/.shepherd/herd.db"
		end
		
		def method_missing m, *args, &block
			@db.send m, *args, &block
		end
	end
end
