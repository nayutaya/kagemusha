# coding: utf-8
# $Id: date.rb 108 2009-02-09 06:04:39Z yuyakato $

require "rubygems"
require "kagemusha/date"

p Date.today.strftime("%Y-%m-%d") #=> today

# Normal Style.
musha = Kagemusha::Date.on(2007, 1, 1)
musha.swap {
  p Date.today.strftime("%Y-%m-%d") #=> 2007-01-01
}

p Date.today.strftime("%Y-%m-%d") #=> today

# Block Style.
Kagemusha::Date.on(2007, 1, 1) {
  p Date.today.strftime("%Y-%m-%d") #=> 2007-01-01
}

p Date.today.strftime("%Y-%m-%d") #=> today
