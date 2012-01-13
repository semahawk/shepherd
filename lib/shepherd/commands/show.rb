module Shepherd::Command
  class Show
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep show [sheep] [options]

options are:
EOB
        opt :oneline, "print one sheep by one line"
        opt :help, "show me and exit"
      end
      
      # This is what we should show. +:everyone+ means every sheep we got
      # and ARGV[0] would be the name of the one specified sheep.
      @what = ARGV[0] || :everyone
      case @what
        when :everyone
          Shepherd::Db.new.execute "select * from sheeps" do |sheep|
            if !@opts[:oneline]
              puts "#{sheep[0]}. \e[1;32m#{sheep[1]}\e[0;0m in \e[1;34m#{sheep[2]}\e[0;0m
   #{sheep[3].to_nice} files #{sheep[4].to_nice} lines #{sheep[5].to_nice} chars
   #{Shepherd::Utils.nice_bytes(sheep[6])} (#{sheep[6].to_nice} bytes)

"
            else
              puts "#{sheep[0]}. \e[1;32m#{sheep[1]}\e[0;0m in \e[1;34m#{sheep[2]}\e[0;0m"
            end
          end
        else
          sheep = Shepherd::Db.new.get_first_row "select * from sheeps where name = ?", @what
          if sheep
            puts <<-EOP
#{sheep[0]}. \e[1;32m#{sheep[1]}\e[0;0m in \e[1;34m#{sheep[2]}\e[0;0m
   #{sheep[3].to_nice} files #{sheep[4].to_nice} lines #{sheep[5].to_nice} chars
   #{Shepherd::Utils.nice_bytes(sheep[6])} (#{sheep[6].to_nice} bytes)
   
   initialized at #{sheep[7]}
       updated at #{sheep[8]}
   
EOP
          else
            puts "[shep] exit 6: there is no such sheep: #{@what}"
            exit 6
          end
      end
    end
    
    def desc
      "list sheeps you have initialized"
    end
  end
end
