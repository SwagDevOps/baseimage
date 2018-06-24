NAME    = 'kamaze/baseimage'
VERSION = '0.0.1'
IMAGE   = "#{NAME}:#{VERSION}"
VERBOSE = !!($stdout.tty? and $stderr.tty?)

task :default => [:'docker:build']

desc 'Build image'
task 'docker:build' do
  sh('docker', 'build', '-t', IMAGE, '--rm', 'image', verbose: VERBOSE)
end

desc 'Run image'
task :'docker:run', [:command] do |task, args|
  command = ['docker', 'run', '-it', IMAGE].concat([args[:command]]).compact

  sh(*command, verbose: VERBOSE)
end
