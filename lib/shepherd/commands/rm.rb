module Shepherd::Command
  class Rm
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep [options] rm <id>
EOB
        opt :quiet, "don't produce output"
        opt :help, "show me and exit", :short => '-h'
      end

      unless id = ARGV.first
        puts "[shep] error: no sheep specified."
        exit 1
      end

      id = id.to_i

      if Shepherd::Db.new.get_first_row "select * from sheeps where id = ? limit 1", id
        if Shepherd::Db.new.execute "delete from sheeps where id = ?", id
          puts "[shep] good: successfuly deleted sheep." unless @opts[:quiet]
        else
          puts "[shep] error: something went wrong." unless @opts[:quiet]
        end
      else
        puts "[shep] error: no such sheep." unless @opts[:quiet]
      end
    end

    def desc
      "remove a specific project"
    end
  end
end
