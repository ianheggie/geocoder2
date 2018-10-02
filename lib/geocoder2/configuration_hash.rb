require 'hash_recursive_merge'

module Geocoder2
  class ConfigurationHash < Hash
    include HashRecursiveMerge

    def method_missing(meth, *args, &block)
      has_key?(meth) ? self[meth] : super
    end
  end
end
