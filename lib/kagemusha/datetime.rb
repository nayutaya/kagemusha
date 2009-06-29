# coding: utf-8

#==============================================================================#
# $Id: datetime.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.join(File.dirname(__FILE__), "date")
require File.join(File.dirname(__FILE__), "time")

#==============================================================================#

class Kagemusha #:nodoc:
  module DateTime #:nodoc:
    def self.at(time_or_year, mon = 1, mday = 1, hour = 0, min = 0, sec = 0, &block)    
      if block_given?
        return self.at(time_or_year, mon, mday, hour, min, sec).swap(&block)
      end

      case time_or_year
      when ::Time
        time = time_or_year
        date = ::Date.new(time.year, time.mon, time.mday)
      when ::Date
        date = time_or_year
        time = ::Time.local(date.year, date.mon, date.mday)
      when ::Integer
        time = ::Time.local(time_or_year, mon, mday, hour, min, sec)
        date = ::Date.new(time_or_year, mon, mday)
      else raise(ArgumentError, "?") # FIXME: message
      end

      datemusha = Kagemusha::Date.on(date)
      timemusha = Kagemusha::Time.at(time)

      return datemusha + timemusha
    end
  end
end

#==============================================================================#
#==============================================================================#
