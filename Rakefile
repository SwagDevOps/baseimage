require 'pathname'

NAME    = 'kamaze/baseimage'
VERSION = '0.0.1'
IMAGE   = "#{NAME}:#{VERSION}"
RUN_AS  = Pathname.new(__FILE__).realpath.dirname.basename.to_s
VERBOSE = !!($stdout.tty? and $stderr.tty?)

task :default => [:'docker:build']

desc 'Build image'
task 'docker:build' do
  sh('docker', 'build', '-t', IMAGE, '--rm', 'image', verbose: VERBOSE)
end

desc 'Run image'
task 'docker:run', [:command] do |task, args|
  command = ['docker', 'run', '-it', IMAGE].concat([args[:command]]).compact

  sh(*command, verbose: VERBOSE)
end

desc 'Start image'
task 'docker:start' do
  command = ['docker', 'run', '-d', '--name', RUN_AS, IMAGE]

  sh(*command, verbose: VERBOSE)
end

desc 'Stop image'
task 'docker:stop' do
  command = ['docker', 'stop', RUN_AS]

  sh(*command, verbose: VERBOSE)
end
