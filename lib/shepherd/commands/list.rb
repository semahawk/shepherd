module Shepherd::Command
  class List
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep list [options]
EOB
        
        opt :one_line, "print each project in one line"
        opt :help, "print me and exit", :short => '-h'
      end

      Shepherd::Db.new.execute "select * from sheeps" do |sheep|
        if !@opts[:one_line]
          puts "#{sheep[0]}. \e[1;32m#{sheep[1]}\e[0;0m in \e[1;34m#{sheep[2]}\e[0;0m
          #{sheep[3].to_nice} files #{sheep[4].to_nice} lines #{sheep[5].to_nice} chars
          #{Shepherd::Utils.nice_bytes(sheep[6])} (#{sheep[6].to_nice} bytes)
          "
        else
          puts "#{sheep[0]}. \e[1;32m#{sheep[1]}\e[0;0m in \e[1;34m#{sheep[2]}\e[0;0m"
        end
      end
    end

    def desc
      "show the projects you've inited"
    end
  end
end
