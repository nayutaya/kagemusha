# coding: utf-8

require "rubygems"
require "kagemusha/rand"

p rand(100) #=> rand
p rand(100) #=> rand
puts "---"

# Normal Style.
musha = Kagemusha::Rand.always(1)
musha.swap {
  p rand(100) #=> 1
  p rand(100) #=> 1
  puts "---"
}

p rand(100) #=> rand
p rand(100) #=> rand
puts "---"

# Block Style.
Kagemusha::Rand.always(1) {
  p rand(100) #=> 1
  p rand(100) #=> 1
  puts "---"
}

p rand(100) #=> rand
p rand(100) #=> rand
puts "---"
