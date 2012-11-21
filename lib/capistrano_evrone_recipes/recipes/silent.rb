require 'colored'

logger.level = Capistrano::Logger::IMPORTANT

STDOUT.sync

$silent_stack      = []
$silent_stack_cur  = nil
$silent_stack_skip = nil

def format_silent(name, options = {})
  s = name.size
  i = (70 - s).abs
  name = name.bold if options[:bold]
  print(name + (" " * i))
end

on :before do
  name = current_task.fully_qualified_name
  if $silent_stack_cur && $silent_stack_cur == $silent_stack.last
    puts ""
  end
  $silent_stack.push name
  $silent_stack_cur = name

  roles = current_task.instance_eval{ @options[:roles] }

  name = "#{name} [#{[roles].flatten.map(&:to_s).join(',')}]" if roles
  format_silent(("  " * ($silent_stack.size - 1)) + "* #{name}")
end

on :after do
  name = current_task.fully_qualified_name
  old = $silent_stack.pop

  spaces = $silent_stack.size
  rs = "DONE".green

  if $silent_stack_skip == true
    rs = "SKIP".yellow
    $silent_stack_skip = nil
  end

  if old == $silent_stack_cur
    puts rs
  else
    format_silent(("  " * (spaces)) + "...", :bold => true)
    puts rs
  end

  $silent_stack_cur = nil
end

