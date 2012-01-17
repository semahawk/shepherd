module Shepherd::Command
  class Show
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep show [sheep] [options]

options are:
EOB
        opt :help, "show me and exit"
      end
      
      if name = ARGV.shift
        sheep = Shepherd::Db.new.get_first_row "select * from sheeps where name = ?", name
        if sheep
          puts "
     id: \e[1;35m#{sheep[0]}\e[0;0m
   path: \e[1;34m#{sheep[1]}\e[0;0m
   name: \e[1;32m#{sheep[2]}\e[0;0m

  state: #{sheep[3].to_nice} files
         #{sheep[4].to_nice} lines
         #{sheep[5].to_nice} chars

         #{Shepherd::Utils.nice_bytes(sheep[6])} (#{sheep[6].to_nice} bytes)
      
  initialized at #{sheep[7]}
      updated at #{sheep[8]}
    "
        else
          puts "[shep] exit 6: there is no such sheep: #{name}"
          exit 6
        end
      else
        puts "no sheep specified"
      end
    end
    
    def desc
      "show a specific project with some details"
    end
  end
end
