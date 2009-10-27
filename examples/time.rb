# coding: utf-8

require "rubygems"
require "kagemusha/time"

p Time.now #=> now

# Normal Style.
musha = Kagemusha::Time.at(2007, 1, 1)
musha.swap {
  p Time.now #=> 2007-01-01 00:00:00
}

p Time.now #=> now

# Block Style.
Kagemusha::Time.at(2007, 1, 1) {
  p Time.now #=> 2007-01-01 00:00:00
}

p Time.now #=> now
