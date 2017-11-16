# -*- encoding: utf-8 -*-
# stub: newrelic-redis 2.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic-redis"
  s.version = "2.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Evan Phoenix"]
  s.date = "2017-07-25"
  s.description = "Redis instrumentation for Newrelic."
  s.email = ["evan@phx.io"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.md"]
  s.files = [".autotest", ".gemtest", "History.txt", "Manifest.txt", "README.md", "Rakefile", "lib/newrelic-redis.rb", "lib/newrelic_redis/instrumentation.rb", "lib/newrelic_redis/version.rb", "newrelic-redis.gemspec", "test/test.conf", "test/test_newrelic_redis.rb"]
  s.homepage = "http://github.com/evanphx/newrelic-redis"
  s.licenses = ["BSD"]
  s.rdoc_options = ["--main", "README.md"]
  s.rubygems_version = "2.2.2"
  s.summary = "Redis instrumentation for Newrelic."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>, ["< 4.0"])
      s.add_runtime_dependency(%q<newrelic_rpm>, ["> 3.11"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.13"])
    else
      s.add_dependency(%q<redis>, ["< 4.0"])
      s.add_dependency(%q<newrelic_rpm>, ["> 3.11"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe>, ["~> 3.13"])
    end
  else
    s.add_dependency(%q<redis>, ["< 4.0"])
    s.add_dependency(%q<newrelic_rpm>, ["> 3.11"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe>, ["~> 3.13"])
  end
end
