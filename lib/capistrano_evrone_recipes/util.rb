module CapistranoEvroneRecipes
  class Util
    class << self
      def ensure_changed_remote_dirs(cap, path)
        if ENV['FORCE'] || !cap.previous_release
          yield
          return
        end
        cap.run changed?(cap, path, recursive: true) do |ch, st, data|
          Capistrano::Configuration.default_io_proc.call(ch,st,data)
          unless data.include?(" is not changed")
            yield
          end
        end
      end

      def ensure_changed_remote_files(cap, path)
        if ENV['FORCE'] || !cap.previous_release
          yield
          return
        end
        cap.run changed?(cap, path) do |ch, st, data|
          Capistrano::Configuration.default_io_proc.call(ch,st,data)
          unless data.include?(" is not changed")
            yield
          end
        end
      end

      def changed?(cap, path, options = {})
        r = options[:recursive] ? "-r" : ""
        %{
          diff #{r} #{cap.previous_release}/#{path} #{cap.latest_release}/#{path} |
            wc -l |
            grep -q -v 0 ;
          ST=$? ;
          if [ $ST -eq 0 ] ; then
            echo '----> #{path} changed' ;
          else
            echo '----> #{path} is not changed' ;
          fi
        }.compact
      end
    end
  end
end
