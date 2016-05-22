module NewNum
  class UndefinedOperationError < StandardError; end
  #自然数
  class NaturalNum < Numeric
    #newメソッドは封印
    private_class_method :new
    #前者と便宜用の数値表示　後者は後で
    attr_reader :val, :prev
    #引数を前者として新しい数を作る　0の時前者はnil
    #後者は参照されてから作るので今はnil
    def initialize (prev = nil)
      @next = nil
      @prev = prev
      if @prev.nil?
        @val = 0
      else
        @val = @prev.val + 1
      end
    end
    @@Zero = nil
    #ゼロを参照　無かったら作る
    def self.Zero
      @@Zero or @@Zero = new()
    end
    def zero?; @prev.nil?; end
    def to_s; "N[#{@val}]"; end
    def to_i; @val; end
    #後者を作るメソッド
    def self.create_next(n)
      raise TypeError unless n.kind_of?(self)
      new(n)
    end

    def next?; not @next.nil?; end
    #後者を参照　無ければ作る
    def next
      return @next if next?
      @next = self.class.create_next(self)
      freeze
      @next
    end

    def self.[](n)
      raise TypeError unless n.integer? and n >= 0
      result = NaturalNum.Zero
      n.times {result = result.next}
      return result
    end
    #1. a + 0 = a
    #2. a + suc(b) = suc(a + b)
    def +(other)
      raise TypeError unless other.kind_of?(self.class)
      return self if other.zero?
      return (self + other.prev).next
    end
    #1. a * 0 = 0
    #2. a * suc(b) = a * b + a
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
        when [true , false] then break -1
        when [true , true ] then break  0
        when [false, true ] then break  1
        end
        x = x.next
      end
    end

    #1'. a + 0 = a  =>  a - 0 = a
    #2'. suc(a) - suc(b) = a - b
    def -(other)
      raise TypeError unless other.kind_of?(self.class)
      if self < other
        raise UndefinedOperationError; end
      if other.zero? then return self; end
      self.prev - other.prev
    end
    #x = q * y + r
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
    def /(other); divmod(other)[0]; end
    def %(other); divmod(other)[1]; end
  end
  N = NaturalNum
end


class Integer
  def to_nn
    NewNum::NaturalNum[self]
  end
end

