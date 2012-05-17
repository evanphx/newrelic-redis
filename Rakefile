# -*- ruby -*-

require 'rubygems'
require 'hoe'

REDIS_DIR = File.expand_path(File.join("..", "test"), __FILE__)
REDIS_CNF = File.join(REDIS_DIR, "test.conf")
REDIS_PID = File.join(REDIS_DIR, "db", "redis.pid")

task :default => :run

desc "Run tests and manage server start/stop"
task :run => [:start, :test, :stop]

desc "Start the Redis server"
task :start do
  redis_running = \
  begin
    File.exists?(REDIS_PID) && Process.kill(0, File.read(REDIS_PID).to_i)
  rescue Errno::ESRCH
    FileUtils.rm REDIS_PID
    false
  end

  unless redis_running
    unless system("which redis-server")
      STDERR.puts "redis-server not in PATH"
      exit 1
    end

    unless system("redis-server #{REDIS_CNF}")
      STDERR.puts "could not start redis-server"
      exit 1
    end
  end
end

desc "Stop the Redis server"
task :stop do
  if File.exists?(REDIS_PID)
    Process.kill "INT", File.read(REDIS_PID).to_i
    FileUtils.rm REDIS_PID
  end
end

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
