# coding: utf-8

#==============================================================================#
# $Id: date.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.join(File.dirname(__FILE__), "core")
require "date"

#==============================================================================#

class Kagemusha #:nodoc:
  module Date #:nodoc:
    def self.on(date_or_year, mon = 1, mday = 1, &block) #:nodoc:
      if block_given?
        return self.on(date_or_year, mon, mday).swap(&block)
      end

      date =
        case date_or_year
        when ::Date    then date_or_year
        when ::Integer then ::Date.new(date_or_year, mon, mday)
        else raise(ArgumentError, "?") # FIXME: message
        end

      musha = Kagemusha.new(::Date)
      musha.defs(:today) { date }

      return musha
    end
  end
end

#==============================================================================#
#==============================================================================#
