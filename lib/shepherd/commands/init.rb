module Shepherd::Command
	class Init
		def init
			@opts = Trollop::options do
				banner <<-EOB
usage: shep [options] init [-h|--help]

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
			
			#Shepherd::Counter.new(@state[:path]) do |count|
				@state[:files] = 8#count.files
				@state[:lines] = 16#count.lines
				@state[:chars] = 32#count.chars
				@state[:bytes] = 64#count.bytes
			#end
			
			puts "Our brave-hearted Shepherd initializes a new project!

   path: \e[1;34m#{@state[:path]}\e[0;0m
   name: \e[1;32m#{@state[:name]}\e[0;0m
  
  state: #{@state[:files]} files
         #{@state[:lines]} lines
         #{@state[:chars]} chars
         
         30 KB (#{@state[:bytes]} bytes)
  
" unless @opts[:quiet]

			# TODO: save to database
			# Shepherd::Db.new.execute "inserting query"
		end
		
		def desc
			"initialize a new project"
		end
	end
end
