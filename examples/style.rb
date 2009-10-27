# coding: utf-8

require "rubygems"
require "kagemusha"

def one_plus_one
  return 1 + 1
end

p one_plus_one #=> 2

# Normal Style.
musha = Kagemusha.new(Fixnum)
musha.def(:+) { |x| 1 }
musha.swap {
  p one_plus_one #=> 1
}

p one_plus_one #=> 2

# Block Style.
Kagemusha.new(Fixnum) { |m|
  m.def(:+) { |x| 1 }
  m.swap {
    p one_plus_one #=> 1
  }
}

p one_plus_one #=> 2

# Chain Style.
Kagemusha.new(Fixnum).
  def(:+) { |x| 1 }.
  swap {
    p one_plus_one #=> 1
  }

p one_plus_one #=> 2
