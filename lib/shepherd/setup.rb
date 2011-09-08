require "fileutils"

module Shepherd
	class Setup
		def initialize
			@schema = <<-EOS
create table if not exists sheeps (
	id integer(11) primary key not null,
	name varchar(128) not null,
	path varchar(256) not null,
	files integer(6) not null,
	lines integer(7) not null,
	chars integer(10) not null,
	bytes integer(10) not null
);
EOS

			crdir "#{Dir.home}/.shepherd"
			crfile "#{Dir.home}/.shepherd/herd.db"
			puts "=> making a real database: #{Dir.home}/.shepherd/herd.db"
			Db.new.execute "#{@schema}"
			exit 0
		end
		
		private
			def crdir dir
				puts "=> creating dir:  #{dir}"
				::FileUtils.mkdir "#{Dir.home}/.shepherd"
			end
			
			def crfile file
				puts "=> creating file: #{file}"
				::FileUtils.touch "#{Dir.home}/.shepherd/herd.db"
			end
	end
end
