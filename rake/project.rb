# frozen_string_literal: true

require 'kamaze/project'

self.tap do |main|
  Kamaze.project do |project|
    project.subject = Class.new { const_set(:VERSION, main.image.version) }
    project.name    = image.name
    project.tasks   = [
      'cs:correct', 'cs:control', 'cs:pre-commit',
      'misc:gitignore',
      'test',
      'version:edit',
    ]
  end.load!
end
