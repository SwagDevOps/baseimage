# -*- coding: utf-8 -*-
# frozen_string_literal: true

# Almost a namespace.
module Boot
  require_relative 'boot/autoload'

  Autoload.register(self, "#{__dir__}/boot")
end
