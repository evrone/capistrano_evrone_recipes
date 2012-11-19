module CapistranoEvroneRecipes
  class Util
    class << self
      def ensure_changed_remote_dirs(cap, path, env_to_force)
        diff = -> { cap.capture("diff -r #{cap.previous_release}/#{path} #{cap.current_release}/#{path} | wc -l").to_i }
        force = ENV["FORCE_#{env_to_force}"].to_i
        if force > 0 || diff > 0
          yield
        else
          cap.logger.info "skip because #{path} not changed"
        end
      end

      def ensure_changed_remote_files(cap, path, env_to_force)
        diff = -> { cap.capture("diff -r #{cap.previous_release}/#{path} #{cap.current_release}/#{path} | wc -l").to_i }
        force = ENV["FORCE_#{env_to_force}"].to_i
        if force > 0 || diff.call > 0
          yield
        else
          cap.logger.info "skip because #{path} not changed"
        end
      end


      def with_server_role(cap, role, &block)
        original, hosts = ENV["HOSTS"], cap.find_servers(:roles => role).map{|i| i.host }.join(",")
        return if hosts.empty?
        begin
          ENV["HOSTS"] = hosts
          yield
        ensure
          ENV["HOSTS"] = original
        end
      end
    end
  end
end
