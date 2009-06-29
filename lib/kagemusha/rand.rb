# coding: utf-8

#==============================================================================#
# $Id: rand.rb 116 2009-02-09 08:04:16Z yuyakato $
#==============================================================================#

require File.join(File.dirname(__FILE__), "core")

#==============================================================================#

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

#==============================================================================#
#==============================================================================#
