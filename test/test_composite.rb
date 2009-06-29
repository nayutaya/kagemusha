# coding: utf-8

#==============================================================================#
# $Id: test_composite.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.dirname(__FILE__) + "/test_helper.rb"
require "date"

#==============================================================================#

class TestComposite < Test::Unit::TestCase
  def setup
    @com = Kagemusha::Composite.new
    @musha1 = Kagemusha.new(Time)
    @musha2 = Kagemusha.new(Date)
    @musha3 = Kagemusha.new(Regexp)
  end

  def test_initialize
    com1 = Kagemusha::Composite.new
    assert_equal([], com1.mocks)

    com2 = Kagemusha::Composite.new(@musha1)
    assert_equal([@musha1], com2.mocks)

    com3 = Kagemusha::Composite.new(@musha1, @musha2)
    assert_equal([@musha1, @musha2], com3.mocks)
  end

  def test_size
    assert_equal(0, @com.size)

    @com << @musha1
    assert_equal(1, @com.size)

    @com << @musha2
    assert_equal(2, @com.size)
  end

  def test_add
    assert_equal([], @com.mocks)

    assert_equal(@com, @com.add(@musha1))
    assert_equal([@musha1], @com.mocks)

    assert_equal(@com, @com << @musha2)
    assert_equal([@musha1, @musha2], @com.mocks)

    assert_raise(ArgumentError) {
      @com << 1
    }
  end

  def test_concat
    com1 = @com
    assert_equal([], com1.mocks)

    com2 = com1.concat(@musha1)
    assert_equal([],        com1.mocks)
    assert_equal([@musha1], com2.mocks)

    com3 = com2 + @musha2
    assert_equal([],                 com1.mocks)
    assert_equal([@musha1],          com2.mocks)
    assert_equal([@musha1, @musha2], com3.mocks)
    
    com4 = Kagemusha::Composite.new(@musha3)

    com5 = com3 + com4
    assert_equal([],                       com1.mocks)
    assert_equal([@musha1],                com2.mocks)
    assert_equal([@musha1, @musha2],       com3.mocks)
    assert_equal([@musha1, @musha2, com4], com5.mocks)
  end

  def test_swap
    @musha1.defs(:now) { :now }
    @musha2.defs(:today) { :today }

    assert_not_equal(:now, Time.now)
    assert_not_equal(:today, Date.today)

    @musha1.swap {
      @musha2.swap {
        assert_equal(:now, Time.now)
        assert_equal(:today, Date.today)
      }
    }

    assert_not_equal(:now, Time.now)
    assert_not_equal(:today, Date.today)

    ret = (@musha1 + @musha2).swap {
      assert_equal(:now, Time.now)
      assert_equal(:today, Date.today)
      1
    }
    assert_equal(1, ret)

    assert_not_equal(:now, Time.now)
    assert_not_equal(:today, Date.today)
  end
end

#==============================================================================#
#==============================================================================#
