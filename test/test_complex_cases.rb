# coding: utf-8

#==============================================================================#
# $Id: test_complex_cases.rb 115 2009-02-09 07:58:44Z yuyakato $
#==============================================================================#

require File.dirname(__FILE__) + "/test_helper.rb"

#==============================================================================#

class TestComplexCases < Test::Unit::TestCase
  module M1
    def m1_instance
      return :m1_instance
    end

    def m1_private_instance
      return :m1_private_instance
    end
    private :m1_private_instance

    def m1_protected_instance
      return :m1_protected_instance
    end
    protected :m1_protected_instance
  end

  module M2
    def m2_class
      return :m2_class
    end

    def m2_private_class
      return :m2_private_class
    end
    private :m2_private_class
  end

  class C1
    include M1
    extend M2

    def self.c1_class
      return :c1_class
    end

    def self.c1_private_class
      return :c1_private_class
    end
    private_class_method :c1_private_class

    def c1_instance
      return :c1_instance
    end

    def c1_private_instance
      return :c1_private_instance
    end
    private :c1_private_instance

    def c1_protected_instance
      return :c1_protected_instance
    end
    protected :c1_protected_instance
  end

  class C2 < C1
  end

  class C3 < C1
  end

  def test_replace_instance_method_defined_on_self_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_instance
    new_value = :c1_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:c1_instance) { new_value }

    assert_equal(old_value, c1.c1_instance)
    assert_equal(old_value, c2.c1_instance)
    assert_equal(old_value, c3.c1_instance)
    c1_method_set = get_method_set(C1)
    c2_method_set = get_method_set(C2)
    c3_method_set = get_method_set(C3)

    musha.swap {
      assert_equal(new_value, c1.c1_instance)
      assert_equal(new_value, c2.c1_instance)
      assert_equal(new_value, c3.c1_instance)
      assert_equal(c1_method_set, get_method_set(C1))
      assert_equal(c2_method_set, get_method_set(C2))
      assert_equal(c3_method_set, get_method_set(C3))
    }

    assert_equal(old_value, c1.c1_instance)
    assert_equal(old_value, c2.c1_instance)
    assert_equal(old_value, c3.c1_instance)
    assert_equal(c1_method_set, get_method_set(C1))
    assert_equal(c2_method_set, get_method_set(C2))
    assert_equal(c3_method_set, get_method_set(C3))

    def c1.c1_instance
      return :singleton
    end

    assert_equal(:singleton, c1.c1_instance)
    assert_equal(old_value,  c2.c1_instance)
    assert_equal(old_value,  c3.c1_instance)

    musha.swap {
      assert_equal(:singleton, c1.c1_instance)
      assert_equal(new_value,  c2.c1_instance)
      assert_equal(new_value,  c3.c1_instance)
    }

    assert_equal(:singleton, c1.c1_instance)
    assert_equal(old_value,  c2.c1_instance)
    assert_equal(old_value,  c3.c1_instance)
  end

  def test_replace_private_instance_method_defined_on_self_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_private_instance
    new_value = :c1_private_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:c1_private_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { c1_private_instance })
    assert_equal(old_value, c2.instance_eval { c1_private_instance })
    assert_equal(old_value, c3.instance_eval { c1_private_instance })
    assert_raise(NoMethodError) { c1.c1_private_instance }
    assert_raise(NoMethodError) { c2.c1_private_instance }
    assert_raise(NoMethodError) { c3.c1_private_instance }

    musha.swap {
      assert_equal(new_value, c1.instance_eval { c1_private_instance })
      assert_equal(new_value, c2.instance_eval { c1_private_instance })
      assert_equal(new_value, c3.instance_eval { c1_private_instance })
      assert_raise(NoMethodError) { c1.c1_private_instance }
      assert_raise(NoMethodError) { c2.c1_private_instance }
      assert_raise(NoMethodError) { c3.c1_private_instance }
    }

    assert_equal(old_value, c1.instance_eval { c1_private_instance })
    assert_equal(old_value, c2.instance_eval { c1_private_instance })
    assert_equal(old_value, c3.instance_eval { c1_private_instance })
    assert_raise(NoMethodError) { c1.c1_private_instance }
    assert_raise(NoMethodError) { c2.c1_private_instance }
    assert_raise(NoMethodError) { c3.c1_private_instance }
  end

  def test_replace_protected_instance_method_defined_on_self_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_protected_instance
    new_value = :c1_protected_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:c1_protected_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { c1_protected_instance })
    assert_equal(old_value, c2.instance_eval { c1_protected_instance })
    assert_equal(old_value, c3.instance_eval { c1_protected_instance })
    assert_raise(NoMethodError) { c1.c1_protected_instance }
    assert_raise(NoMethodError) { c2.c1_protected_instance }
    assert_raise(NoMethodError) { c3.c1_protected_instance }

    musha.swap {
      assert_equal(new_value, c1.instance_eval { c1_protected_instance })
      assert_equal(new_value, c2.instance_eval { c1_protected_instance })
      assert_equal(new_value, c3.instance_eval { c1_protected_instance })
      assert_raise(NoMethodError) { c1.c1_protected_instance }
      assert_raise(NoMethodError) { c2.c1_protected_instance }
      assert_raise(NoMethodError) { c3.c1_protected_instance }
    }

    assert_equal(old_value, c1.instance_eval { c1_protected_instance })
    assert_equal(old_value, c2.instance_eval { c1_protected_instance })
    assert_equal(old_value, c3.instance_eval { c1_protected_instance })
    assert_raise(NoMethodError) { c1.c1_protected_instance }
    assert_raise(NoMethodError) { c2.c1_protected_instance }
    assert_raise(NoMethodError) { c3.c1_protected_instance }
  end

  def test_replace_class_method_defined_on_self_class
    old_value = :c1_class
    new_value = :c1_class_replaced1

    musha = Kagemusha.new(C1)
    musha.defs(:c1_class) { new_value }

    assert_equal(old_value, C1.c1_class)
    assert_equal(old_value, C2.c1_class)
    assert_equal(old_value, C3.c1_class)

    musha.swap {
      assert_equal(new_value, C1.c1_class)
      assert_equal(new_value, C2.c1_class)
      assert_equal(new_value, C3.c1_class)
    }

    assert_equal(old_value, C1.c1_class)

    if RUBY_VERSION < "1.9.0"
      # @1.8.6 TypeError: singleton method bound for a different object
      assert_raise(TypeError) { C2.c1_class }
      assert_raise(TypeError) { C3.c1_class }
    else
      # @1.9.1 No Error
      assert_equal(old_value, C2.c1_class)
      assert_equal(old_value, C3.c1_class)
    end
  end

  def test_replace_private_class_method_defined_on_self_class
    old_value = :c1_private_class
    new_value = :c1_private_class_replaced1

    musha = Kagemusha.new(C1)
    musha.defs(:c1_private_class) { new_value }

    assert_equal(old_value, C1.instance_eval { c1_private_class })
    assert_equal(old_value, C2.instance_eval { c1_private_class })
    assert_equal(old_value, C3.instance_eval { c1_private_class })
    assert_raise(NoMethodError) { C1.c1_private_class }
    assert_raise(NoMethodError) { C2.c1_private_class }
    assert_raise(NoMethodError) { C3.c1_private_class }

    musha.swap {
      assert_equal(new_value, C1.instance_eval { c1_private_class })
      assert_equal(new_value, C2.instance_eval { c1_private_class })
      assert_equal(new_value, C3.instance_eval { c1_private_class })
      assert_raise(NoMethodError) { C1.c1_private_class }
      assert_raise(NoMethodError) { C2.c1_private_class }
      assert_raise(NoMethodError) { C3.c1_private_class }
    }

    assert_equal(old_value, C1.instance_eval { c1_private_class }) # FIXME: NameError: undefined local variable or method `c1_private_class' for TestComplexCases::C1:Class
    assert_equal(old_value, C2.instance_eval { c1_private_class })
    assert_equal(old_value, C3.instance_eval { c1_private_class })
    assert_raise(NoMethodError) { C1.c1_private_class }
    assert_raise(NoMethodError) { C2.c1_private_class }
    assert_raise(NoMethodError) { C3.c1_private_class }
  end

  def test_replace_instance_method_defined_on_parent_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_instance
    new_value = :c1_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:c1_instance) { new_value }

    assert_equal(old_value, c1.c1_instance)
    assert_equal(old_value, c2.c1_instance)
    assert_equal(old_value, c3.c1_instance)

    musha.swap {
      assert_equal(old_value, c1.c1_instance)
      assert_equal(new_value, c2.c1_instance)
      assert_equal(old_value, c3.c1_instance)
    }

    assert_equal(old_value, c1.c1_instance)
    assert_equal(old_value, c2.c1_instance)
    assert_equal(old_value, c3.c1_instance)

    def c2.c1_instance
      return :singleton
    end

    assert_equal(old_value,  c1.c1_instance)
    assert_equal(:singleton, c2.c1_instance)
    assert_equal(old_value,  c3.c1_instance)

    musha.swap {
      assert_equal(old_value,  c1.c1_instance)
      assert_equal(:singleton, c2.c1_instance)
      assert_equal(old_value,  c3.c1_instance)
    }

    assert_equal(old_value,  c1.c1_instance)
    assert_equal(:singleton, c2.c1_instance)
    assert_equal(old_value,  c3.c1_instance)
  end

  def test_replace_private_instance_method_defined_on_parent_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_private_instance
    new_value = :c1_private_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:c1_private_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { c1_private_instance })
    assert_equal(old_value, c2.instance_eval { c1_private_instance })
    assert_equal(old_value, c3.instance_eval { c1_private_instance })
    assert_raise(NoMethodError) { c1.c1_private_instance }
    assert_raise(NoMethodError) { c2.c1_private_instance }
    assert_raise(NoMethodError) { c3.c1_private_instance }

    musha.swap {
      assert_equal(old_value, c1.instance_eval { c1_private_instance })
      assert_equal(new_value, c2.instance_eval { c1_private_instance })
      assert_equal(old_value, c3.instance_eval { c1_private_instance })
      assert_raise(NoMethodError) { c1.c1_private_instance }
      assert_raise(NoMethodError) { c2.c1_private_instance }
      assert_raise(NoMethodError) { c3.c1_private_instance }
    }

    assert_equal(old_value, c1.instance_eval { c1_private_instance })
    assert_equal(old_value, c2.instance_eval { c1_private_instance })
    assert_equal(old_value, c3.instance_eval { c1_private_instance })
    assert_raise(NoMethodError) { c1.c1_private_instance }
    assert_raise(NoMethodError) { c2.c1_private_instance }
    assert_raise(NoMethodError) { c3.c1_private_instance }
  end

  def test_replace_protected_instance_method_defined_on_parent_class
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :c1_protected_instance
    new_value = :c1_protected_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:c1_protected_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { c1_protected_instance })
    assert_equal(old_value, c2.instance_eval { c1_protected_instance })
    assert_equal(old_value, c3.instance_eval { c1_protected_instance })
    assert_raise(NoMethodError) { c1.c1_protected_instance }
    assert_raise(NoMethodError) { c2.c1_protected_instance }
    assert_raise(NoMethodError) { c3.c1_protected_instance }

    musha.swap {
      assert_equal(old_value, c1.instance_eval { c1_protected_instance })
      assert_equal(new_value, c2.instance_eval { c1_protected_instance })
      assert_equal(old_value, c3.instance_eval { c1_protected_instance })
      assert_raise(NoMethodError) { c1.c1_protected_instance }
      assert_raise(NoMethodError) { c2.c1_protected_instance }
      assert_raise(NoMethodError) { c3.c1_protected_instance }
    }

    assert_equal(old_value, c1.instance_eval { c1_protected_instance })
    assert_equal(old_value, c2.instance_eval { c1_protected_instance })
    assert_equal(old_value, c3.instance_eval { c1_protected_instance })
    assert_raise(NoMethodError) { c1.c1_protected_instance }
    assert_raise(NoMethodError) { c2.c1_protected_instance }
    assert_raise(NoMethodError) { c3.c1_protected_instance }
  end

  def test_replace_class_method_defined_on_parent_class
    old_value = :c1_class
    new_value = :c1_class_replaced2

    musha = Kagemusha.new(C2)
    musha.defs(:c1_class) { new_value }

    assert_equal(old_value, C1.c1_class)
    assert_equal(old_value, C2.c1_class)
    assert_equal(old_value, C3.c1_class)

    musha.swap {
      assert_equal(old_value, C1.c1_class)
      assert_equal(new_value, C2.c1_class)
      assert_equal(old_value, C3.c1_class)
    }

    assert_equal(old_value, C1.c1_class)
    assert_equal(old_value, C2.c1_class)
    assert_equal(old_value, C3.c1_class)
  end

  def test_replace_private_class_method_defined_on_parent_class
    old_value = :c1_private_class
    new_value = :c1_private_class_replaced2

    musha = Kagemusha.new(C2)
    musha.defs(:c1_private_class) { new_value }

    assert_equal(old_value, C1.instance_eval { c1_private_class })
    assert_equal(old_value, C2.instance_eval { c1_private_class })
    assert_equal(old_value, C3.instance_eval { c1_private_class })
    assert_raise(NoMethodError) { C1.c1_private_class }
    assert_raise(NoMethodError) { C2.c1_private_class }
    assert_raise(NoMethodError) { C3.c1_private_class }

    musha.swap {
      assert_equal(old_value, C1.instance_eval { c1_private_class })
      assert_equal(new_value, C2.instance_eval { c1_private_class })
      assert_equal(old_value, C3.instance_eval { c1_private_class })
      assert_raise(NoMethodError) { C1.c1_private_class }
      assert_raise(NoMethodError) { C2.c1_private_class }
      assert_raise(NoMethodError) { C3.c1_private_class }
    }

    assert_equal(old_value, C1.instance_eval { c1_private_class })
    assert_equal(old_value, C2.instance_eval { c1_private_class })
    assert_equal(old_value, C3.instance_eval { c1_private_class })
    assert_raise(NoMethodError) { C1.c1_private_class }
    assert_raise(NoMethodError) { C2.c1_private_class }
    assert_raise(NoMethodError) { C3.c1_private_class }
  end

  def test_replace_instance_method_defined_on_self_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_instance
    new_value = :m1_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:m1_instance) { new_value }

    assert_equal(old_value, c1.m1_instance)
    assert_equal(old_value, c2.m1_instance)
    assert_equal(old_value, c3.m1_instance)

    musha.swap {
      assert_equal(new_value, c1.m1_instance)
      assert_equal(new_value, c2.m1_instance)
      assert_equal(new_value, c3.m1_instance)
    }

    assert_equal(old_value, c1.m1_instance)
    assert_equal(old_value, c2.m1_instance)
    assert_equal(old_value, c3.m1_instance)

    def c1.m1_instance
      return :singleton
    end

    assert_equal(:singleton, c1.m1_instance)
    assert_equal(old_value,   c2.m1_instance)
    assert_equal(old_value,   c3.m1_instance)

    musha.swap {
      assert_equal(:singleton, c1.m1_instance)
      assert_equal(new_value,  c2.m1_instance)
      assert_equal(new_value,  c3.m1_instance)
    }

    assert_equal(:singleton, c1.m1_instance)
    assert_equal(old_value,   c2.m1_instance)
    assert_equal(old_value,   c3.m1_instance)
  end

  def test_replace_private_instance_method_defined_on_self_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_private_instance
    new_value = :m1_private_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:m1_private_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { m1_private_instance })
    assert_equal(old_value, c2.instance_eval { m1_private_instance })
    assert_equal(old_value, c3.instance_eval { m1_private_instance })
    assert_raise(NoMethodError) { c1.m1_private_instance }
    assert_raise(NoMethodError) { c2.m1_private_instance }
    assert_raise(NoMethodError) { c3.m1_private_instance }

    musha.swap {
      assert_equal(new_value, c1.instance_eval { m1_private_instance })
      assert_equal(new_value, c2.instance_eval { m1_private_instance })
      assert_equal(new_value, c3.instance_eval { m1_private_instance })
      assert_raise(NoMethodError) { c1.m1_private_instance }
      assert_raise(NoMethodError) { c2.m1_private_instance }
      assert_raise(NoMethodError) { c3.m1_private_instance }
    }

    assert_equal(old_value, c1.instance_eval { m1_private_instance })
    assert_equal(old_value, c2.instance_eval { m1_private_instance })
    assert_equal(old_value, c3.instance_eval { m1_private_instance })
    assert_raise(NoMethodError) { c1.m1_private_instance }
    assert_raise(NoMethodError) { c2.m1_private_instance }
    assert_raise(NoMethodError) { c3.m1_private_instance }
  end

  def test_replace_protected_instance_method_defined_on_self_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_protected_instance
    new_value = :m1_protected_instance_replaced1

    musha = Kagemusha.new(C1)
    musha.def(:m1_protected_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { m1_protected_instance })
    assert_equal(old_value, c2.instance_eval { m1_protected_instance })
    assert_equal(old_value, c3.instance_eval { m1_protected_instance })
    assert_raise(NoMethodError) { c1.m1_protected_instance }
    assert_raise(NoMethodError) { c2.m1_protected_instance }
    assert_raise(NoMethodError) { c3.m1_protected_instance }

    musha.swap {
      assert_equal(new_value, c1.instance_eval { m1_protected_instance })
      assert_equal(new_value, c2.instance_eval { m1_protected_instance })
      assert_equal(new_value, c3.instance_eval { m1_protected_instance })
      assert_raise(NoMethodError) { c1.m1_protected_instance }
      assert_raise(NoMethodError) { c2.m1_protected_instance }
      assert_raise(NoMethodError) { c3.m1_protected_instance }
    }

    assert_equal(old_value, c1.instance_eval { m1_protected_instance })
    assert_equal(old_value, c2.instance_eval { m1_protected_instance })
    assert_equal(old_value, c3.instance_eval { m1_protected_instance })
    assert_raise(NoMethodError) { c1.m1_protected_instance }
    assert_raise(NoMethodError) { c2.m1_protected_instance }
    assert_raise(NoMethodError) { c3.m1_protected_instance }
  end

  def test_replace_class_method_defined_on_self_class_extending_module
    old_value = :m2_class
    new_value = :m2_class_replaced1

    musha = Kagemusha.new(C1)
    musha.defs(:m2_class) { new_value }

    assert_equal(old_value, C1.m2_class)
    assert_equal(old_value, C2.m2_class)
    assert_equal(old_value, C3.m2_class)

    musha.swap {
      assert_equal(new_value, C1.m2_class)
      assert_equal(new_value, C2.m2_class)
      assert_equal(new_value, C3.m2_class)
    }

    assert_equal(old_value, C1.m2_class)
    assert_equal(old_value, C2.m2_class)
    assert_equal(old_value, C3.m2_class)
  end

  def test_replace_private_class_method_defined_on_self_class_extending_module
    old_value = :m2_private_class
    new_value = :m2_private_class_replaced1

    musha = Kagemusha.new(C1)
    musha.defs(:m2_private_class) { new_value }

    assert_equal(old_value, C1.instance_eval { m2_private_class })
    assert_equal(old_value, C2.instance_eval { m2_private_class })
    assert_equal(old_value, C3.instance_eval { m2_private_class })
    assert_raise(NoMethodError) { C1.m2_private_class }
    assert_raise(NoMethodError) { C2.m2_private_class }
    assert_raise(NoMethodError) { C3.m2_private_class }

    musha.swap {
      assert_equal(new_value, C1.instance_eval { m2_private_class })
      assert_equal(new_value, C2.instance_eval { m2_private_class })
      assert_equal(new_value, C3.instance_eval { m2_private_class })
      assert_raise(NoMethodError) { C1.m2_private_class }
      assert_raise(NoMethodError) { C2.m2_private_class }
      assert_raise(NoMethodError) { C3.m2_private_class }
    }

    assert_equal(old_value, C1.instance_eval { m2_private_class })
    assert_equal(old_value, C2.instance_eval { m2_private_class })
    assert_equal(old_value, C3.instance_eval { m2_private_class })
    assert_raise(NoMethodError) { C1.m2_private_class }
    assert_raise(NoMethodError) { C2.m2_private_class }
    assert_raise(NoMethodError) { C3.m2_private_class }
  end

  def test_replace_instance_method_defined_on_parent_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_instance
    new_value = :m1_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:m1_instance) { new_value }

    assert_equal(old_value, c1.m1_instance)
    assert_equal(old_value, c2.m1_instance)
    assert_equal(old_value, c3.m1_instance)

    musha.swap {
      assert_equal(old_value, c1.m1_instance)
      assert_equal(new_value, c2.m1_instance)
      assert_equal(old_value, c3.m1_instance)
    }

    assert_equal(old_value, c1.m1_instance)
    assert_equal(old_value, c2.m1_instance)
    assert_equal(old_value, c3.m1_instance)

    def c2.m1_instance
      return :singleton
    end

    assert_equal(old_value,  c1.m1_instance)
    assert_equal(:singleton, c2.m1_instance)
    assert_equal(old_value,  c3.m1_instance)

    musha.swap {
      assert_equal(old_value,  c1.m1_instance)
      assert_equal(:singleton, c2.m1_instance)
      assert_equal(old_value,  c3.m1_instance)
    }

    assert_equal(old_value,  c1.m1_instance)
    assert_equal(:singleton, c2.m1_instance)
    assert_equal(old_value,  c3.m1_instance)
  end

  def test_replace_private_instance_method_defined_on_parent_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_private_instance
    new_value = :m1_private_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:m1_private_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { m1_private_instance })
    assert_equal(old_value, c2.instance_eval { m1_private_instance })
    assert_equal(old_value, c3.instance_eval { m1_private_instance })
    assert_raise(NoMethodError) { c1.m1_private_instance }
    assert_raise(NoMethodError) { c2.m1_private_instance }
    assert_raise(NoMethodError) { c3.m1_private_instance }

    musha.swap {
      assert_equal(old_value, c1.instance_eval { m1_private_instance })
      assert_equal(new_value, c2.instance_eval { m1_private_instance })
      assert_equal(old_value, c3.instance_eval { m1_private_instance })
      assert_raise(NoMethodError) { c1.m1_private_instance }
      assert_raise(NoMethodError) { c2.m1_private_instance }
      assert_raise(NoMethodError) { c3.m1_private_instance }
    }

    assert_equal(old_value, c1.instance_eval { m1_private_instance })
    assert_equal(old_value, c2.instance_eval { m1_private_instance })
    assert_equal(old_value, c3.instance_eval { m1_private_instance })
    assert_raise(NoMethodError) { c1.m1_private_instance }
    assert_raise(NoMethodError) { c2.m1_private_instance }
    assert_raise(NoMethodError) { c3.m1_private_instance }
  end

  def test_replace_protected_instance_method_defined_on_parent_class_including_module
    c1 = C1.new
    c2 = C2.new
    c3 = C3.new

    old_value = :m1_protected_instance
    new_value = :m1_protected_instance_replaced2

    musha = Kagemusha.new(C2)
    musha.def(:m1_protected_instance) { new_value }

    assert_equal(old_value, c1.instance_eval { m1_protected_instance })
    assert_equal(old_value, c2.instance_eval { m1_protected_instance })
    assert_equal(old_value, c3.instance_eval { m1_protected_instance })
    assert_raise(NoMethodError) { c1.m1_protected_instance }
    assert_raise(NoMethodError) { c2.m1_protected_instance }
    assert_raise(NoMethodError) { c3.m1_protected_instance }

    musha.swap {
      assert_equal(old_value, c1.instance_eval { m1_protected_instance })
      assert_equal(new_value, c2.instance_eval { m1_protected_instance })
      assert_equal(old_value, c3.instance_eval { m1_protected_instance })
      assert_raise(NoMethodError) { c1.m1_protected_instance }
      assert_raise(NoMethodError) { c2.m1_protected_instance }
      assert_raise(NoMethodError) { c3.m1_protected_instance }
    }

    assert_equal(old_value, c1.instance_eval { m1_protected_instance })
    assert_equal(old_value, c2.instance_eval { m1_protected_instance })
    assert_equal(old_value, c3.instance_eval { m1_protected_instance })
    assert_raise(NoMethodError) { c1.m1_protected_instance }
    assert_raise(NoMethodError) { c2.m1_protected_instance }
    assert_raise(NoMethodError) { c3.m1_protected_instance }
  end

  def test_replace_class_method_defined_on_parent_class_extending_module
    old_value = :m2_class
    new_value = :m2_class_replaced2

    musha = Kagemusha.new(C2)
    musha.defs(:m2_class) { new_value }

    assert_equal(old_value, C1.m2_class)
    assert_equal(old_value, C2.m2_class)
    assert_equal(old_value, C3.m2_class)

    musha.swap {
      assert_equal(old_value, C1.m2_class)
      assert_equal(new_value, C2.m2_class)
      assert_equal(old_value, C3.m2_class)
    }

    assert_equal(old_value, C1.m2_class)
    assert_equal(old_value, C2.m2_class)
    assert_equal(old_value, C3.m2_class)
  end

  def test_replace_private_class_method_defined_on_parent_class_extending_module
    old_value = :m2_private_class
    new_value = :m2_private_class_replaced2

    musha = Kagemusha.new(C2)
    musha.defs(:m2_private_class) { new_value }

    assert_equal(old_value, C1.instance_eval { m2_private_class })
    assert_equal(old_value, C2.instance_eval { m2_private_class })
    assert_equal(old_value, C3.instance_eval { m2_private_class })
    assert_raise(NoMethodError) { C1.m2_private_class }
    assert_raise(NoMethodError) { C2.m2_private_class }
    assert_raise(NoMethodError) { C3.m2_private_class }

    musha.swap {
      assert_equal(old_value, C1.instance_eval { m2_private_class })
      assert_equal(new_value, C2.instance_eval { m2_private_class })
      assert_equal(old_value, C3.instance_eval { m2_private_class })
      assert_raise(NoMethodError) { C1.m2_private_class }
      assert_raise(NoMethodError) { C2.m2_private_class }
      assert_raise(NoMethodError) { C3.m2_private_class }
    }

    assert_equal(old_value, C1.instance_eval { m2_private_class })
    assert_equal(old_value, C2.instance_eval { m2_private_class })
    assert_equal(old_value, C3.instance_eval { m2_private_class })
    assert_raise(NoMethodError) { C1.m2_private_class }
    assert_raise(NoMethodError) { C2.m2_private_class }
    assert_raise(NoMethodError) { C3.m2_private_class }
  end

  private

  def get_method_set(obj)
    return {
      :self => {
        :public                   => obj.public_methods(false),
        :public_with_inherited    => obj.public_methods(true),
        :protected                => obj.protected_methods(false),
        :protected_with_inherited => obj.protected_methods(true),
        :private                  => obj.private_methods(false),
        :private_with_inherited   => obj.private_methods(true),
      },
      :instance => (obj.kind_of?(Module) ? {
        :public                   => obj.public_instance_methods(false),
        :public_with_inherited    => obj.public_instance_methods(true),
        :protected                => obj.protected_instance_methods(false),
        :protected_with_inherited => obj.protected_instance_methods(true),
        :private                  => obj.private_instance_methods(false),
        :private_with_inherited   => obj.private_instance_methods(true),
      } : nil),
    }
  end
end

#==============================================================================#
#==============================================================================#
