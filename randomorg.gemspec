# -*- encoding: utf-8 -*-
# stub: randomorg 1.0.0b ruby lib

Gem::Specification.new do |s|
  s.name = "randomorg".freeze
  s.version = "1.0.0b"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Lindblom".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-11-24"
  s.description = "Ruby-RandomOrg helps you make sure that random number of yours really is, you know, random.".freeze
  s.email = ["janlindblom@fastmail.fm".freeze]
  s.files = [".gitignore".freeze, ".rspec".freeze, "CODE_OF_CONDUCT.md".freeze, "Gemfile".freeze, "LICENSE.txt".freeze, "README.md".freeze, "Rakefile".freeze, "VERSION".freeze, "lib/random_org.rb".freeze, "lib/random_org/api_client.rb".freeze, "lib/random_org/api_error.rb".freeze, "lib/random_org/api_server_error.rb".freeze, "lib/random_org/argument_error.rb".freeze, "lib/random_org/basic.rb".freeze, "lib/random_org/configuration.rb".freeze, "lib/random_org/response.rb".freeze, "lib/random_org/response/blobs.rb".freeze, "lib/random_org/response/data.rb".freeze, "lib/random_org/response/decimal_fractions.rb".freeze, "lib/random_org/response/gaussians.rb".freeze, "lib/random_org/response/integer_sequences.rb".freeze, "lib/random_org/response/integers.rb".freeze, "lib/random_org/response/random_data.rb".freeze, "lib/random_org/response/strings.rb".freeze, "lib/random_org/response/usage.rb".freeze, "lib/random_org/response/uuids.rb".freeze, "lib/random_org/rng.rb".freeze, "lib/random_org/wrong_api_key_error.rb".freeze, "randomorg.gemspec".freeze]
  s.homepage = "https://bitbucket.org/janlindblom/ruby-randomorg".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.3".freeze
  s.summary = "Ruby-RandomOrg leverages the random.org API for true random.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["> 1.14"])
      s.add_development_dependency(%q<dotenv>.freeze, ["~> 2"])
      s.add_development_dependency(%q<pry>.freeze, ["~> 0.12"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_development_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.71"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.16"])
      s.add_development_dependency(%q<simplecov-rcov>.freeze, ["~> 0.2"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<solargraph>.freeze, ["~> 0.37"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["~> 2"])
      s.add_runtime_dependency(%q<version>.freeze, ["~> 1"])
    else
      s.add_dependency(%q<bundler>.freeze, ["> 1.14"])
      s.add_dependency(%q<dotenv>.freeze, ["~> 2"])
      s.add_dependency(%q<pry>.freeze, ["~> 0.12"])
      s.add_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3"])
      s.add_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.4"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.71"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
      s.add_dependency(%q<simplecov-rcov>.freeze, ["~> 0.2"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
      s.add_dependency(%q<solargraph>.freeze, ["~> 0.37"])
      s.add_dependency(%q<rest-client>.freeze, ["~> 2"])
      s.add_dependency(%q<version>.freeze, ["~> 1"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["> 1.14"])
    s.add_dependency(%q<dotenv>.freeze, ["~> 2"])
    s.add_dependency(%q<pry>.freeze, ["~> 0.12"])
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3"])
    s.add_dependency(%q<rspec_junit_formatter>.freeze, ["~> 0.4"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.71"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.16"])
    s.add_dependency(%q<simplecov-rcov>.freeze, ["~> 0.2"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.9"])
    s.add_dependency(%q<solargraph>.freeze, ["~> 0.37"])
    s.add_dependency(%q<rest-client>.freeze, ["~> 2"])
    s.add_dependency(%q<version>.freeze, ["~> 1"])
  end
end
