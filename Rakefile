lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rake/version_task"
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require "yard"
require "yard/rake/yardoc_task"
require 'random_org'

s = Gem::Specification.new do |spec|
  spec.name          = 'ruby-randomorg'
  spec.version       = RandomOrg::VERSION
  spec.authors       = ['Jan Lindblom']
  spec.email         = ['janlindblom@fastmail.fm']

  spec.summary       = 'Ruby-RandomOrg leverages the random.org API for true random.'
  spec.description   = 'Ruby-RandomOrg helps you make sure that random number of yours really is, you know, random.'
  spec.homepage      = 'https://bitbucket.org/janlindblom/ruby-randomorg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'dotenv', '~> 2.2'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  spec.add_development_dependency 'rubocop', '~> 0.54'
  spec.add_development_dependency 'simplecov', '~> 0.16'
  spec.add_development_dependency 'simplecov-rcov', '~> 0.2'
  spec.add_development_dependency 'yard', '~> 0.9'
  spec.add_runtime_dependency 'rest-client', '~> 2.0'
  spec.add_runtime_dependency 'version', '~> 1.1'
end

Rake::VersionTask.new do |task|
  task.with_gemspec = s
  task.with_git = false
end

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

task default: [:build, :spec, :yard, :rubocop]
