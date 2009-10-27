# coding: utf-8

require File.dirname(__FILE__) + "/test_helper.rb"
require File.dirname(__FILE__) + "/../lib/kagemusha/time"

class TestKagemushaTime < Test::Unit::TestCase
  def setup
  end

  def test_at
    musha1 = Kagemusha::Time.at(2007, 1, 2, 3, 4, 5)
    assert_equal(Time, musha1.instance_eval { @klass })
    musha1.swap {
      assert_equal(Time.local(2007, 1, 2, 3, 4, 5), Time.now)
    }

    musha2 = Kagemusha::Time.at(Time.local(1984, 5, 11))
    musha2.swap {
      assert_equal(Time.local(1984, 5, 11), Time.now)
    }

    assert_raise(ArgumentError) {
      Kagemusha::Time.at(:symbol)
    }
  end

  def test_at_with_block
    ret = Kagemusha::Time.at(2007, 1, 2, 3, 4, 5) {
      assert_equal(Time.local(2007, 1, 2, 3, 4, 5), Time.now)
      1
    }

    assert_equal(1, ret)
  end
end
