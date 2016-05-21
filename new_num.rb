module NewNum
  class UndefinedOperationError < StandardError
  end
  class NaturalNum < Numeric
    private_class_method :new
    attr_reader :val, :prev
    def initialize (prev = nil)
      @next = nil
      @prev = prev
      if @prev.nil?
        @val = 0
      else
        @val = @prev.val + 1
        @prev.set_next(self)
      end
    end
    @@Zero = nil
    def self.Zero
      @@Zero or @@Zero = new()
    end
    def zero?; @prev.nil?; end
    def to_s; "N[#{@val}]"; end
    def to_i; @val; end
    def self.create_next(n)
      raise TypeError unless n.kind_of?(self)
      return n.next if n.next?
      new(n)
    end

    def next?; not @next.nil?; end
    def next
      return @next if next?
      self.class.create_next(self)
    end
    def set_next(n)
      @next = n
      freeze
    end
    protected :set_next

    def self.[](n)
      raise TypeError unless n.integer? and n >= 0
      result = NaturalNum.Zero
      n.times {result = result.next}
      return result
    end
    def +(other)
      raise TypeError unless other.kind_of?(self.class)
      return self if other.zero?
      return (self + other.prev).next
    end
    def *(other)
      raise TypeError unless other.kind_of?(self.class)
      return @@Zero if other == @@Zero
      return (self * other.prev) + self
    end
    def <=>(other)
      raise TypeError unless other.kind_of?(self.class)
      x = @@Zero
      while true
        case [x.equal?(self), x.equal?(other)]
        when [true, true]  then break  0
        when [true, false] then break -1
        when [false, true] then break  1
        end
        x = x.next
      end
    end

    def -(other)
      raise TypeError unless other.kind_of?(self.class)
      if self < other
        raise UndefinedOperationError; end
      if other.zero? then return self; end
      self.prev - other.prev
    end
    def divmod(other)
      raise TypeError unless other.kind_of?(self.class)
      if other.zero?
        raise ZeroDivisionError; end
      q = @@Zero
      tmp = other
      while self >= tmp
        q = q.next
        tmp += other
      end
      [q, self + other - tmp]
    end
    def /(other)
      divmod(other)[0]
    end
    def %(other)
      divmod(other)[1]
    end
  end
  N = NaturalNum
end


class Integer
  def to_nn
    NewNum::NaturalNum[self]
  end
end

