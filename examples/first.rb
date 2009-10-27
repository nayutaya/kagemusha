# coding: utf-8

require "rubygems"
require "kagemusha"

musha = Kagemusha.new(Time)
musha.defs(:now) { self.local(1984, 5, 11) }
musha.def(:+) { |other| other }

p Time.now                #=> now
p Time.now + 60 * 60 * 24 #=> now + 24 hours
puts "---"

musha.swap {
  p Time.now                #=> 1984-05-11 00:00:00
  p Time.now + 60 * 60 * 24 #=> 86400
  puts "---"
}

p Time.now                #=> now
p Time.now + 60 * 60 * 24 #=> now + 24 hours
puts "---"
