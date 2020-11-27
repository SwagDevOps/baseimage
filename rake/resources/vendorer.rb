# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

autoload(:YAML, 'yaml')
# @type [Object] image
# @type [Pathname] vendor
# @type [Vendorer] self
image.path.join('vendorer.yml').realpath.read.yield_self do |s|
  YAML.safe_load(s).sort.to_h
end.tap do |h|
  if Object.const_defined?(:Vendorer) and self.is_a?(Vendorer)
    h.each { |k, v| self.public_send(:folder, *[vendor.join(k.to_s)].concat(v)) }
  end
end
# Local Variables:
# mode: ruby
# End:
