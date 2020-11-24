# frozen_string_literal: true

# Load dotenv files ---------------------------------------------------
# noinspection RubyResolve
%w[.env .env.dist].tap do |files|
  lambda do
    autoload(:Dotenv, 'dotenv')

    Dotenv
  end.call.load(*files)
end

# Set progname --------------------------------------------------------
lambda do
  if Gem::Specification.find_all_by_name('sys-proc').any?
    require 'sys/proc'

    Sys::Proc.progname = ENV.fetch('progname', 'rake')
  end
end.call
