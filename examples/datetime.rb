# coding: utf-8
# $Id: datetime.rb 108 2009-02-09 06:04:39Z yuyakato $

require "rubygems"
require "kagemusha/datetime"

p Date.today.strftime("%Y-%m-%d") #=> today
p Time.now                        #=> now
puts "---"

# Normal Style.
musha = Kagemusha::DateTime.at(1984, 5, 11, 5, 15, 30)
musha.swap {
  p Date.today.strftime("%Y-%m-%d") #=> 1984-05-11
  p Time.now                        #=> 1984-05-11 05:15:30
  puts "---"
}

p Date.today.strftime("%Y-%m-%d") #=> today
p Time.now                        #=> now
puts "---"

# Block Style.
Kagemusha::DateTime.at(1984, 5, 11, 5, 15, 30) {
  p Date.today.strftime("%Y-%m-%d") #=> 1984-05-11
  p Time.now                        #=> 1984-05-11 05:15:30
  puts "---"
}

p Date.today.strftime("%Y-%m-%d") #=> today
p Time.now                        #=> now
puts "---"
