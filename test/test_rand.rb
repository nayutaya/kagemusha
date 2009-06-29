# coding: utf-8

#==============================================================================#
# $Id: test_rand.rb 108 2009-02-09 06:04:39Z yuyakato $
#==============================================================================#

require File.dirname(__FILE__) + "/test_helper.rb"
require File.dirname(__FILE__) + "/../lib/kagemusha/rand"

#==============================================================================#

class TestKagemushaRand < Test::Unit::TestCase
  def setup
  end

  def test_always
    musha = Kagemusha::Rand.always(1)
    assert_equal(Kernel, musha.instance_eval { @klass })

    assert_equal([0, 1, 2], (1..100).map { rand(3) }.sort.uniq)

    musha.swap {
      assert_equal(1, rand)
      assert_equal(1, rand(2))
      assert_equal(1, rand(3))
      assert_equal(1, rand(4))
      assert_equal(1, rand(5))
    }

    assert_equal([0, 1, 2], (1..100).map { rand(3) }.sort.uniq)
  end

  def test_always_with_block
    ret = Kagemusha::Rand.always(1) {
      assert_equal(1, rand)
      assert_equal(1, rand(2))
      assert_equal(1, rand(3))
      assert_equal(1, rand(4))
      assert_equal(1, rand(5))
      1
    }

    assert_equal(1, ret)
  end
end

#==============================================================================#
#==============================================================================#
