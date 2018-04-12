require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require "yard"
require "yard/rake/yardoc_task"

RuboCop::RakeTask.new(:rubocop) do |task|
  task.patterns = ['lib/**/*.rb']
  # only show the files with failures
  #task.formatters = ['worst']
  # don't abort rake on failure
  task.fail_on_error = false
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.stats_options = ['--list-undoc']
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
