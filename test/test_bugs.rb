# coding: utf-8

require File.dirname(__FILE__) + "/test_helper.rb"

class TestBugs < Test::Unit::TestCase
  # MEMO:
  #   * rubyneko - KagemushaとActiveRecordの不具合
  #     http://ujihisa.nowa.jp/entry/6a4d5a6423
  #   * rubyneko - KagemushaとActiveRecordの不具合(2)
  #     http://ujihisa.nowa.jp/entry/c45f6db41e
  #   * Non free as in air - KagemushaとActiveRecordの不具合(2)
  #     http://www.kuwashima.org/niki/?date=20071116
  #   * KagemushaとActiveRecordの不具合の解消 - Hello, world! - s21g
  #     http://blog.s21g.com/articles/656
  def test_report01
    parent_c = Class.new
    parent_m = class << parent_c; self; end
    child_c  = Class.new(parent_c)

    parent_m.instance_eval { define_method(:target) { :original } }

    musha = Kagemusha.new(child_c)
    musha.defs(:target) { :replaced }

    assert_equal(:original, child_c.target)

    musha.swap {
      assert_equal(:replaced, child_c.target)
    }

    # TypeError: singleton method bound for a different object
    assert_nothing_raised {
      assert_equal(:original, child_c.target)
    }
  end

  def test_report01_failure_mechanism
    parent_c = Class.new
    parent_m = class << parent_c; self; end
    child_c  = Class.new(parent_c)
    child_m  = class << child_c; self; end

    parent_m.instance_eval { define_method(:target) { :original } }

    assert_equal(:original, child_c.target)

    name = :target
    new_method = proc { :replaced }
    old_method = child_m.instance_method(name)
    child_m.instance_eval { define_method(name, new_method) }

    assert_equal(:replaced, child_c.target)

    if RUBY_VERSION < "1.9.0"
      child_m.instance_eval { define_method(name, old_method) }

      # @1.8.6 TypeError: singleton method bound for a different object
      assert_raise(TypeError) {
        child_c.target
      }
    else
      # @1.9.1 TypeError: can't bind singleton method to a different class
      assert_raise(TypeError) {
        child_m.instance_eval { define_method(name, old_method) }
      }
    end
  end

  def test_report01_correct_mechanism
    parent_c = Class.new
    parent_m = class << parent_c; self; end
    child_c  = Class.new(parent_c)
    child_m  = class << child_c; self; end

    parent_m.instance_eval { define_method(:target) { :original } }

    assert_equal(:original, child_c.target)

    name = :target
    new_method = proc { :replaced }
    old_method = child_m.instance_method(name)

    assert_equal(false, child_c.singleton_methods(false).map { |n| n.to_sym }.include?(name))

    child_m.instance_eval { define_method(name, new_method) }

    assert_equal(:replaced, child_c.target)

    child_m.instance_eval { remove_method(name) } # define_method -> remove_method

    assert_equal(:original, child_c.target)
  end

  def test_report02
    musha = Kagemusha.new(Kernel)
    musha.def(:Integer) { |x| :replaced }

    assert(1, Integer("1"))

    musha.swap {
      assert_equal(:replaced, Integer("1"))
    }

    # NoMethodError: undefined method `Integer' for #<TestBugs:0x.......>
    assert(1, Integer("1"))
  end
end
