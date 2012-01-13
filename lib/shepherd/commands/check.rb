module Shepherd::Command
  class Check
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep check [id] [options]
EOB
        opt :help, "show me and exit", :short => '-h'
      end
      
      if id = ARGV.shift
        check_one id.to_i
      else
        check_all
      end
    end

    def check_all
      n = 0
      Shepherd::Db.new.execute "select * from sheeps" do |sheep|
        n += 1
        update_one sheep[0]
        count = Shepherd::Db.new.execute("select count(*) from sheeps").first.first
        puts "         ---\n\n" if n < count
      end
    end

    def check_one id
      out = ""

      sheep = Shepherd::Db.new.get_first_row "select * from sheeps where id = ?", id
      if sheep
        out += "   name: \e[1;35m#{sheep[1]}\e[0;0m from \e[1;34m#{sheep[2]}\e[0;0m\n\n"
        Shepherd::Counter.new(sheep[2]) do |count|
          files = count.files - sheep[3]
          if files < 0
            files = files.to_s[1..-1].to_i
            out += "  state: \e[1;34m#{count.files.to_nice}\e[0;0m files (#{sheep[3].to_nice} \e[1;31m- #{files.to_nice}\e[0;0m)"
          elsif files == 0
            out += "  state: \e[1;34m#{count.files.to_nice}\e[0;0m files\n"
          else
            out += "  state: \e[1;34m#{count.files.to_nice}\e[0;0m files (#{sheep[3].to_nice} \e[1;32m+ #{files.to_nice}\e[0;0m)\n"
          end

          lines = count.lines - sheep[4]
          if lines < 0
            lines = lines.to_s[1..-1].to_i
            out += "         \e[1;34m#{count.lines.to_nice}\e[0;0m lines (#{sheep[4].to_nice} \e[1;31m- #{lines.to_nice}\e[0;0m)"
          elsif lines == 0
            out += "         \e[1;34m#{count.lines.to_nice}\e[0;0m lines\n"
          else
            out += "         \e[1;34m#{count.lines.to_nice}\e[0;0m lines (#{sheep[4].to_nice} \e[1;32m+ #{lines.to_nice}\e[0;0m)\n"
          end

          chars = count.chars - sheep[5]
          if chars < 0
            chars = chars.to_s[1..-1].to_i
            out += "         \e[1;34m#{count.chars.to_nice}\e[0;0m chars (#{sheep[5].to_nice} \e[1;31m- #{chars.to_nice}\e[0;0m)\n\n"
          elsif chars == 0
            out += "         \e[1;34m#{count.chars.to_nice}\e[0;0m chars\n\n"
          else
            out += "         \e[1;34m#{count.chars.to_nice}\e[0;0m chars (#{sheep[5].to_nice} \e[1;32m+ #{chars.to_nice}\e[0;0m)\n\n"
          end

          bytes = count.bytes - sheep[6]
          if bytes < 0
            bytes = bytes.to_s[1..-1].to_i
            out += "         \e[1;34m#{Shepherd::Utils.nice_bytes count.bytes}\e[0;0m bytes (#{Shepherd::Utils.nice_bytes sheep[6]} \e[1;31m- #{Shepherd::Utils.nice_bytes bytes}\e[0;0m)\n"
          elsif bytes == 0
            out += "         \e[1;34m#{Shepherd::Utils.nice_bytes count.bytes}\e[0;0m\n"
          else
            out += "         \e[1;34m#{Shepherd::Utils.nice_bytes count.bytes}\e[0;0m bytes (#{Shepherd::Utils.nice_bytes sheep[6]} \e[1;32m+ #{Shepherd::Utils.nice_bytes bytes}\e[0;0m)\n"
          end

          out += "\n  since: #{sheep[8]}"

          puts "#{out}\n\n"
        end
      else
        puts "[shep] error: no such sheep."
      end
    end

    def desc
      "see how the projects have grown"
    end
  end
end
