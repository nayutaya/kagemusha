# coding: utf-8

require File.join(File.dirname(__FILE__), "core")

class Kagemusha #:nodoc:
  module Rand
    def self.always(num, &block)
      if block_given?
        return self.always(num).swap(&block)
      end

      musha = Kagemusha.new(Kernel)
      musha.def(:rand) { |*x| num }

      return musha
    end
  end
end
