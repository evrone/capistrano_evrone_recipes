module CapistranoEvroneRecipes
  class Util
    class << self
      def ensure_changed_remote_dirs(cap, path)
        diff = if cap.previous_release
                 -> { cap.capture("diff -r #{cap.previous_release}/#{path} #{cap.current_release}/#{path} | wc -l").to_i }
               else
                 -> { 1 }
               end
        force = ENV["FORCE"].to_i
        if force > 0 || diff.call > 0
          yield
        else
          cap.logger.info "skip because #{path} not changed"
          $silent_stack_skip = true
        end
      end

      def ensure_changed_remote_files(cap, path)
        diff = if cap.previous_release
                 -> { cap.capture("diff -r #{cap.previous_release}/#{path} #{cap.current_release}/#{path} | wc -l").to_i }
               else
                 -> { 1 }
               end
        force = ENV["FORCE"].to_i
        if force > 0 || diff.call > 0
          yield
        else
          cap.logger.info "skip because #{path} not changed"
          $silent_stack_skip = true
        end
      end


      def with_roles(cap, role)
        original = ENV['ROLES']
        begin
          ENV["ROLES"] = role
          yield
        ensure
          ENV["ROLES"] = original
        end
      end
    end
  end
end
