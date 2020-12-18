# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

autoload(:YAML, 'yaml')

# @type [Object] image
# @type [Pathname] vendor
image.path.join('vendorer.yml').realpath.read.yield_self { |s| YAML.safe_load(s).sort.to_h }.tap do |config|
  if Object.const_defined?(:Vendorer) and self.is_a?(Vendorer)
    # @see https://github.com/grosser/vendorer
    # @type [Vendorer] self
    config.each do |k, v|
      args = [vendor.join(k.to_s)].concat(v.reject { |arg| arg.is_a?(Hash) })
      kwargs = v.keep_if { |h| h.is_a?(Hash) }.last.transform_keys(&:to_sym)

      self.public_send(:folder, *args, **kwargs)
    end
  end
end

# Local Variables:
# mode: ruby
# End:
