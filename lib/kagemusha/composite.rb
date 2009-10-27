# coding: utf-8

class Kagemusha
  class Composite
    def initialize(*mocks)
      @mocks = []
      mocks.each { |mock| self << mock }
    end

    attr_reader :mocks

    def size
      return @mocks.size
    end

    def add(mock)
      raise(ArgumentError) unless mock.kind_of?(Kagemusha) || mock.kind_of?(Kagemusha::Composite)
      @mocks << mock
      return self
    end
    alias << add

    def concat(mock)
      return self.class.new(*self.mocks) << mock
    end
    alias + concat

    def swap(&block)
      src = (0...self.size).to_a.reverse.inject("return yield") { |memo, index|
        "@mocks[#{index}].swap { #{memo} }"
      }
      return eval(src, &block)
    end
  end
end
