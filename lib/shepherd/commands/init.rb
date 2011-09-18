module Shepherd::Command
	class Init
		def init
			@opts = Trollop::options do
				banner <<-EOB
usage: shep [options] init [-h|--help]

examples:
  cd /my/awesome/program
  shep init                              # name of that sheep would be 'program'
  
  shep init --path /my/awesome/program   # here as well
  
  shep init --path /my/awesome/program\\
            --name yay                   # it's would be 'yay'

options are:
EOB
				opt :path, "a root path to the project", :default => Dir.pwd
				opt :name, "set a projects name (default: a top directory name from --path will be taken)", :type => :string
				opt :quiet, "don't show what's going on"
				opt :help, "show me and exit", :short => '-h'
			end
			
			@state = {}
			# delete the last '/' in path if present
			@state[:path] = @opts[:path].chomp "/"
			# use this top directory name unless --name is set
			@state[:name] = @opts[:name] ? @opts[:name] : @opts[:path].split("/").last
			
			# let's check if the --path exists
			if !Dir.exists? @state[:path]
				puts "[shep] exit 5: no such directory: #{@state[:path]}"
				exit 5
			end
			
			# let's check if there already is a sheep with the same path and/or name
			res = Shepherd::Db.new.get_first_row "select * from sheeps where name = ? or path = ?", @state[:name], @state[:path]
			if res
				puts "[shep] exit 4: there already is a sheep with that name and/or path"
				exit 4
			end
			
			Shepherd::Counter.new(@state[:path]) do |count|
				@state[:files] = count.files
				@state[:lines] = count.lines
				@state[:chars] = count.chars
				@state[:bytes] = count.bytes
			end
			
			puts "Our brave-hearted Shepherd gained a new sheep!

   path: \e[1;34m#{@state[:path]}\e[0;0m
   name: \e[1;32m#{@state[:name]}\e[0;0m
  
  state: #{@state[:files]} files
         #{@state[:lines]} lines
         #{@state[:chars]} chars
         
         #{Shepherd::Utils.nice_bytes(@state[:bytes])} (#{@state[:bytes]} bytes)
  
" unless @opts[:quiet]
			
			Shepherd::Db.new.execute "insert into sheeps(id, name, path, files, lines, chars, bytes, inited_at) values(NULL, ?, ?, ?, ?, ?, ?, datetime())", @state[:name], @state[:path], @state[:files], @state[:lines], @state[:chars], @state[:bytes]
		end
		
		def desc
			"initialize a new project"
		end
	end
end
