# -*- encoding: utf-8 -*-
# stub: newrelic-redis 2.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "newrelic-redis".freeze
  s.version = "2.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Evan Phoenix".freeze]
  s.date = "2017-05-17"
  s.description = "Redis instrumentation for Newrelic.".freeze
  s.email = ["evan@phx.io".freeze]
  s.extra_rdoc_files = ["History.txt".freeze, "Manifest.txt".freeze, "README.md".freeze]
  s.files = [".autotest".freeze, "History.txt".freeze, "Manifest.txt".freeze, "README.md".freeze, "Rakefile".freeze, "lib/newrelic-redis.rb".freeze, "lib/newrelic_redis/instrumentation.rb".freeze, "lib/newrelic_redis/version.rb".freeze, "newrelic-redis.gemspec".freeze, "test/test.conf".freeze, "test/test_newrelic_redis.rb".freeze]
  s.homepage = "http://github.com/evanphx/newrelic-redis".freeze
  s.licenses = ["BSD".freeze]
  s.rdoc_options = ["--main".freeze, "README.md".freeze]
  s.rubygems_version = "2.6.11".freeze
  s.summary = "Redis instrumentation for Newrelic.".freeze

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<redis>.freeze, ["< 4.0"])
      s.add_runtime_dependency(%q<newrelic_rpm>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 5"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<hoe>.freeze, ["~> 3.16"])
    else
      s.add_dependency(%q<redis>.freeze, ["< 4.0"])
      s.add_dependency(%q<newrelic_rpm>.freeze, ["~> 4.0"])
      s.add_dependency(%q<minitest>.freeze, [">= 5"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
      s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
    end
  else
    s.add_dependency(%q<redis>.freeze, ["< 4.0"])
    s.add_dependency(%q<newrelic_rpm>.freeze, ["~> 4.0"])
    s.add_dependency(%q<minitest>.freeze, [">= 5"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.0"])
    s.add_dependency(%q<hoe>.freeze, ["~> 3.16"])
  end
end
