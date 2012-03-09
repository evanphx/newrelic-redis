# -*- ruby -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :gemspec
Hoe.plugin :git

HOE = Hoe.spec 'newrelic-redis' do
  developer 'Evan Phoenix', 'evan@phx.io'

  dependency "redis", "< 3.0"
  dependency "newrelic_rpm", "~> 3.0"
end

file "#{HOE.spec.name}.gemspec" => ['Rakefile'] do |t|
  puts "Generating #{t.name}"
  File.open(t.name, 'wb') { |f| f.write HOE.spec.to_ruby }
end

desc "Generate or update the standalone gemspec file for the project"
task :gemspec => ["#{HOE.spec.name}.gemspec"]

# vim: syntax=ruby
