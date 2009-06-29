# coding: utf-8

#==============================================================================#
# $Id: core.rb 113 2009-02-09 07:30:04Z yuyakato $
#==============================================================================#

require File.join(File.dirname(__FILE__), "composite")

#==============================================================================#

class Kagemusha #:nodoc:
  def initialize(klass) #:nodoc:
    @klass            = klass
    @meta             = class << @klass; self; end
    @class_methods    = {}
    @instance_methods = {}

    if block_given?
      yield(self)
    end
  end

  def define_class_method(name, &block) #:nodoc:
    @class_methods[name.to_s.to_sym] = block
    return self
  end
  alias :defs :define_class_method

  def undefine_class_method(name) #:nodoc:
    @class_methods[name.to_s.to_sym] = false
    return self
  end
  alias :undefs :undefine_class_method

  def define_instance_method(name, &block) #:nodoc:
    @instance_methods[name.to_s.to_sym] = block
    return self
  end
  alias :def :define_instance_method

  def undefine_instance_method(name) #:nodoc:
    @instance_methods[name.to_s.to_sym] = false
    return self
  end
  alias :undef :undefine_instance_method

  def swap #:nodoc:
    recover_class_methods = @class_methods.map { |name, proc|
      if proc
        begin
          # replace method
          attr = get_accessibility(@meta, name)

          methods = to_symbols(@klass.singleton_methods(false))

          method = @meta.instance_method(name)

          @meta.instance_eval { define_method(name, proc) }
          @meta.instance_eval { private(name) } if attr == :private

          (methods.include?(name) ? [name, :define, nil, method] : [name, :remove])
        rescue NameError
          # insert method
          @meta.instance_eval { define_method(name, proc) }
          [name, :undef]
        end
      else
        begin
          # remove method
          method = @meta.instance_method(name)
          @meta.instance_eval { undef_method(name) }
          [name, :define, nil, method] # FIXME: attr
        rescue NameError
          [name, :nop]
        end
      end
    }

    recover_instance_methods = @instance_methods.map { |name, proc|
      if proc
        begin
          # replace method
          attr = get_accessibility(@klass, name)

          methods  = to_symbols(@klass.public_instance_methods(false))
          methods += to_symbols(@klass.protected_instance_methods(false))
          methods += to_symbols(@klass.private_instance_methods(false))

          method = @klass.instance_method(name)

          @klass.instance_eval { define_method(name, proc) }
          @klass.instance_eval { protected(name) } if attr == :protected
          @klass.instance_eval { private(name)   } if attr == :private

          (methods.include?(name) ? [name, :define, attr, method] : [name, :remove])
        rescue NameError
          # insert method
          @klass.instance_eval { define_method(name, proc) }
          [name, :undef]
        end
      else
        begin
          # remove method
          method = @klass.instance_method(name)
          @klass.instance_eval { undef_method(name) }
          [name, :define, nil, method] # FIXME: attr
        rescue NameError
          [name, :nop]
        end
      end
    }

    return yield
  ensure
    recover_class_methods.each { |name, type, attr, method|
      case type
      when :nop    then # nop
      when :remove then @meta.instance_eval { remove_method(name) }
      when :undef  then @meta.instance_eval { undef_method(name) }
      when :define
        @meta.instance_eval { define_method(name, method) }
        @meta.instance_eval { private(name) } if attr == :private
      else raise("BUG")
      end
    }
    recover_instance_methods.each { |name, type, attr, method|
      case type
      when :nop    then # nop
      when :remove then @klass.instance_eval { remove_method(name) }
      when :undef  then @klass.instance_eval { undef_method(name) }
      when :define
        @klass.instance_eval { define_method(name, method) }
        @klass.instance_eval { protected(name) } if attr == :protected
        @klass.instance_eval { private(name)   } if attr == :private
      else raise("BUG")
      end
    }
  end

  def concat(mock)
    return Kagemusha::Composite.new(self, mock)
  end
  alias + concat

  private

  def get_accessibility(target, name)
    return :public    if to_symbols(target.public_instance_methods(true)).include?(name)
    return :protected if to_symbols(target.protected_instance_methods(true)).include?(name)
    return :private   if to_symbols(target.private_instance_methods(true)).include?(name)
    return nil
  end

  def to_symbols(array)
    return array.map { |item| item.to_sym }
  end
end

#==============================================================================#
#==============================================================================#
