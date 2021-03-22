# -*- coding: utf-8 -*-
# frozen_string_literal: true

# Almost a namespace.
module Boot
  require_relative 'boot/autoload'

  Autoload.new.call(self)
end
