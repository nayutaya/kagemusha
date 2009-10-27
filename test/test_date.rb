# coding: utf-8

require File.dirname(__FILE__) + "/test_helper.rb"
require File.dirname(__FILE__) + "/../lib/kagemusha/date"

class TestKagemushaDate < Test::Unit::TestCase
  def setup
  end

  def test_on
    musha1 = Kagemusha::Date.on(2007, 1, 2)
    assert_equal(Date, musha1.instance_eval { @klass })
    musha1.swap {
      assert_equal(Date.new(2007, 1, 2), Date.today)
    }

    musha2 = Kagemusha::Date.on(Date.new(1984, 5, 11))
    musha2.swap {
      assert_equal(Date.new(1984, 5, 11), Date.today)
    }

    assert_raise(ArgumentError) {
      Kagemusha::Date.on(:symbol)
    }
  end

  def test_on_with_block
    ret = Kagemusha::Date.on(2007, 1, 2) {
      assert_equal(Date.new(2007, 1, 2), Date.today)
      1
    }

    assert_equal(1, ret)
  end
end
