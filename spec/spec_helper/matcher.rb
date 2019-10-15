# frozen_string_literal: true

Dir.glob("#{__dir__}/matcher/**/*.rb").each do |fp|
  require(fp)
end
