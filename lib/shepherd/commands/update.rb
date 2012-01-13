module Shepherd::Command
  class Update
    def init
      @opts = Trollop::options do
        banner <<-EOB
usage: shep update [sheep]
EOB
        opt :help, "show me and exit", :short => '-h'
      end

      if sheep = ARGV.shift
        update_one sheep
      else
        update_all
      end
    end

    def update_all
      puts "updat'd all"
    end

    def update_one name
      sheep = Shepherd::Db.new.get_first_row "select * from sheeps where name = ?", name

      state = {}
      Shepherd::Counter.new(sheep[2]) do |count|
        state[:files] = count.files
        state[:lines] = count.lines
        state[:chars] = count.chars
        state[:bytes] = count.bytes
      end

      if Shepherd::Db.new.execute "update sheeps set files = ?, lines = ?, chars = ?, bytes = ?, updated_at = datetime() where name = ?", state[:files], state[:lines], state[:chars], state[:bytes], name
        puts "[shep] nice: #{name} was successfuly updated."
      else
        puts "[shep] error: something went wrong.."
      end
    end

    def desc
      "update sheep's current state"
    end
  end
end
