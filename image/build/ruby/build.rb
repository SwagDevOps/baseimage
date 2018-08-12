# frozen_string_literal: true

# Provide build utilities.
module Build
  autoload :Gem, "#{__dir__}/build/gem"
  autoload :UserManager, "#{__dir__}/build/user_manager"
  autoload :Shell, "#{__dir__}/build/shell"

  class << self
    def sh(*cmd)
      Shell.__send__(:sh, *cmd)
    end
  end
end
