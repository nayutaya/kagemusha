# coding: utf-8

#==============================================================================#
# $Id: time.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.join(File.dirname(__FILE__), "core")

#==============================================================================#

class Kagemusha #:nodoc:
  module Time #:nodoc:
    def self.at(time_or_year, mon = 1, mday = 1, hour = 0, min = 0, sec = 0, &block)
      if block_given?
        return self.at(time_or_year, mon, mday, hour, min, sec).swap(&block)
      end

      time =
        case time_or_year
        when ::Time    then time_or_year
        when ::Integer then ::Time.local(time_or_year, mon, mday, hour, min, sec)
        else raise(ArgumentError, "?") # FIXME: message
        end

      musha = Kagemusha.new(::Time)
      musha.defs(:now) { time }

      return musha
    end
  end
end

#==============================================================================#
#==============================================================================#
