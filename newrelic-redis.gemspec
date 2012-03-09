# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "newrelic-redis"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Evan Phoenix"]
  s.date = "2012-03-09"
  s.description = "Redis instrumentation for Newrelic."
  s.email = ["evan@phx.io"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = [".autotest", "History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/newrelic_redis.rb", "lib/newrelic_redis/instrumentation.rb", "lib/newrelic_redis/version.rb", "test/test_newrelic_redis.rb", ".gemtest"]
  s.homepage = "http://github.com/evanphx/newrelic-redis"
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "newrelic-redis"
  s.rubygems_version = "1.8.17"
  s.summary = "Redis instrumentation for Newrelic."
  s.test_files = ["test/test_newrelic_redis.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, ["< 3.0"])
      s.add_runtime_dependency(%q<newrelic_rpm>, ["~> 3.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_development_dependency(%q<hoe>, ["~> 2.16"])
    else
      s.add_dependency(%q<redis>, ["< 3.0"])
      s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
      s.add_dependency(%q<hoe>, ["~> 2.16"])
    end
  else
    s.add_dependency(%q<redis>, ["< 3.0"])
    s.add_dependency(%q<newrelic_rpm>, ["~> 3.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
    s.add_dependency(%q<hoe>, ["~> 2.16"])
  end
end
