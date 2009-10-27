# coding: utf-8

require File.dirname(__FILE__) + "/test_helper.rb"

class TestKagemusha < Test::Unit::TestCase
  def setup
    @musha = Kagemusha.new(String)
  end

  def test_initialize
    klass = String
    meta  = class << klass; self; end

    assert_kind_of(Kagemusha, @musha)
    assert_equal(klass, @musha.instance_eval { @klass })
    assert_equal(meta,  @musha.instance_eval { @meta })
    assert_equal({}, @musha.instance_eval { @class_methods })
    assert_equal({}, @musha.instance_eval { @instance_methods })
  end

  def test_initialize_with_block
    arg = nil

    ret = Kagemusha.new(String) { |x|
      arg = x
    }

    assert_kind_of(Kagemusha, ret)
    assert_same(ret, arg)
  end

  def test_define_class_method_and_undefine
    block1 = proc { 1 }
    block2 = proc { 2 }

    assert_equal(nil, @musha.instance_eval { @class_methods[:foo] })
    assert_equal(nil, @musha.instance_eval { @class_methods[:bar] })

    ret = @musha.define_class_method(:foo, &block1)

    assert_same(ret, @musha)
    assert_equal(block1, @musha.instance_eval { @class_methods[:foo] })
    assert_equal(nil,    @musha.instance_eval { @class_methods[:bar] })

    ret = @musha.define_class_method("bar", &block2)

    assert_same(ret, @musha)
    assert_equal(block1, @musha.instance_eval { @class_methods[:foo] })
    assert_equal(block2, @musha.instance_eval { @class_methods[:bar] })

    ret = @musha.undefine_class_method("foo")

    assert_same(ret, @musha)
    assert_equal(false,  @musha.instance_eval { @class_methods[:foo] })
    assert_equal(block2, @musha.instance_eval { @class_methods[:bar] })

    ret = @musha.undefine_class_method(:bar)

    assert_same(ret, @musha)
    assert_equal(false, @musha.instance_eval { @class_methods[:foo] })
    assert_equal(false, @musha.instance_eval { @class_methods[:bar] })
  end

  def test_defs_and_undefs
    block = proc { 1 }

    assert_equal(nil, @musha.instance_eval { @class_methods[:foo] })

    ret = @musha.defs(:foo, &block)

    assert_same(ret, @musha)
    assert_equal(block, @musha.instance_eval { @class_methods[:foo] })

    ret = @musha.undefs(:foo)

    assert_same(ret, @musha)
    assert_equal(false, @musha.instance_eval { @class_methods[:foo] })
  end

  def test_define_instance_method_and_undefine
    block1 = proc { 1 }
    block2 = proc { 2 }

    assert_equal(nil, @musha.instance_eval { @instance_methods[:foo] })
    assert_equal(nil, @musha.instance_eval { @instance_methods[:bar] })

    ret = @musha.define_instance_method(:foo, &block1)

    assert_same(ret, @musha)
    assert_equal(block1, @musha.instance_eval { @instance_methods[:foo] })
    assert_equal(nil,    @musha.instance_eval { @instance_methods[:bar] })

    ret = @musha.define_instance_method("bar", &block2)

    assert_same(ret, @musha)
    assert_equal(block1, @musha.instance_eval { @instance_methods[:foo] })
    assert_equal(block2, @musha.instance_eval { @instance_methods[:bar] })

    ret = @musha.undefine_instance_method("foo")

    assert_same(ret, @musha)
    assert_equal(false,  @musha.instance_eval { @instance_methods[:foo] })
    assert_equal(block2, @musha.instance_eval { @instance_methods[:bar] })

    ret = @musha.undefine_instance_method(:bar)

    assert_same(ret, @musha)
    assert_equal(false, @musha.instance_eval { @instance_methods[:foo] })
    assert_equal(false, @musha.instance_eval { @instance_methods[:bar] })
  end

  def test_def_and_undef
    block = proc { 1 }

    assert_equal(nil, @musha.instance_eval { @instance_methods[:foo] })

    ret = @musha.def(:foo, &block)

    assert_same(ret, @musha)
    assert_equal(block, @musha.instance_eval { @instance_methods[:foo] })

    ret = @musha.undef(:foo)

    assert_same(ret, @musha)
    assert_equal(false, @musha.instance_eval { @instance_methods[:foo] })
  end

  def test_swap_class_method
    @musha = Kagemusha.new(Regexp)
    @musha.defs(:compile) { |string| /bar/ }

    assert_equal(/foo/, Regexp.compile("foo"))

    ret = @musha.swap {
      assert_equal(/bar/, Regexp.compile("foo"))
      1
    }

    assert_equal(1, ret)
    assert_equal(/foo/, Regexp.compile("foo"))
  end

  def test_swap_instance_method
    target = "foo"
    @musha.def(:to_s) { "bar" }

    assert_equal("foo", target.to_s)

    ret = @musha.swap {
      assert_equal("bar", target.to_s)
      1
    }

    assert_equal(1, ret)
    assert_equal("foo", target.to_s)
  end

  def test_insert_new_class_method
    assert_raise(NoMethodError) {
      String.foo
    }

    @musha.defs(:foo) { :ok }

    assert_raise(NoMethodError) {
      String.foo
    }
    assert_nothing_raised {
      @musha.swap {
        assert_equal(:ok, String.foo)
      }
    }
    assert_raise(NoMethodError) {
      String.foo
    }
  end

  def test_remove_exist_class_method
    assert_nothing_raised {
      String.clone
    }

    @musha.undefs(:clone)

    assert_nothing_raised {
      String.clone
    }
    assert_raise(NoMethodError) {
      @musha.swap {
        String.clone
      }
    }
    assert_nothing_raised {
      String.clone
    }
  end

  def test_insert_new_instance_method
    assert_raise(NoMethodError) {
      "".foo
    }

    @musha.def(:foo) { :ok }

    assert_raise(NoMethodError) {
      "".foo
    }
    assert_nothing_raised {
      @musha.swap {
        assert_equal(:ok, "".foo)
      }
    }
    assert_raise(NoMethodError) {
      "".foo
    }
  end

  def test_remove_exist_instance_method
    assert_nothing_raised {
      "".clone
    }

    @musha.undef(:clone)

    assert_nothing_raised {
      "".clone
    }
    assert_raise(NoMethodError) {
      @musha.swap {
        "".clone
      }
    }
    assert_nothing_raised {
      "".clone
    }
  end

  def test_concat
    musha2 = Kagemusha.new(Time)
    musha3 = Kagemusha.new(Regexp)

    com1 = @musha.concat(musha2)
    assert_equal([@musha, musha2], com1.mocks)

    com2 = musha3 + com1
    assert_equal([musha3, com1], com2.mocks)
  end
end
