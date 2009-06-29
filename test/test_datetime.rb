# coding: utf-8

#==============================================================================#
# $Id: test_datetime.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.dirname(__FILE__) + "/test_helper.rb"
require File.dirname(__FILE__) + "/../lib/kagemusha/date"
require File.dirname(__FILE__) + "/../lib/kagemusha/time"
require File.dirname(__FILE__) + "/../lib/kagemusha/datetime"

#==============================================================================#

class TestKagemushaDateTime < Test::Unit::TestCase
  def setup
  end

  def test_at
    musha1 = Kagemusha::DateTime.at(2007, 1, 2, 3, 4, 5)
    musha1.swap {
      assert_equal(Date.new(2007, 1, 2), Date.today)
      assert_equal(Time.local(2007, 1, 2, 3, 4, 5), Time.now)
    }

    musha2 = Kagemusha::DateTime.at(Date.new(1984, 5, 11))
    musha2.swap {
      assert_equal(Date.new(1984, 5, 11), Date.today)
      assert_equal(Time.local(1984, 5, 11), Time.now)
    }

    musha3 = Kagemusha::DateTime.at(Time.local(1984, 5, 11))
    musha3.swap {
      assert_equal(Date.new(1984, 5, 11), Date.today)
      assert_equal(Time.local(1984, 5, 11), Time.now)
    }

    assert_raise(ArgumentError) {
      Kagemusha::DateTime.at(:symbol)
    }
  end

  def test_at_with_block
    ret = Kagemusha::DateTime.at(2007, 1, 2, 3, 4, 5) {
      assert_equal(Date.new(2007, 1, 2), Date.today)
      assert_equal(Time.local(2007, 1, 2, 3, 4, 5), Time.now)
      1
    }

    assert_equal(1, ret)
  end
end

#==============================================================================#
#==============================================================================#
