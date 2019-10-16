# frozen_string_literal: true

Dir.glob("#{__FILE__.gsub(/\.rb$/, '')}/**/*.rb").each do |fp|
  require(fp)
end
