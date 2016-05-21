require_relative "new_num.rb"
require "minitest/unit"

MiniTest::Unit.autorun

class Test自然数 < MiniTest::Unit::TestCase
  def setup
    @zero = NewNum::N.Zero
    @a = NewNum::N[13]
    @b = NewNum::N[4]
  end
  def test_自然数には0がある
    assert_kind_of(NewNum::N, @zero)
  end
  def test_各自然数には「次の数」が存在する
    assert_kind_of(NewNum::N, @zero.next)
    assert_kind_of(NewNum::N, @a.next)
    assert_kind_of(NewNum::N, @b.next)
  end
  def test_0より「前の数」は存在しない
    assert_nil(@zero.prev)
  end
  def test_異なる数の後者は異なる
    assert((@a != @b) && (@a.next != @b.next))
  end

  def test_普通に加算が出来る
    x, y = 3, 4
    assert_equal(x.to_nn + y.to_nn, (x+y).to_nn)
  end
  def test_普通に乗算も出来る
    x, y = 3, 4
    assert_equal(x.to_nn * y.to_nn, (x*y).to_nn)
  end
  def test_減算も可能
    x, y = 7, 3
    assert_equal(x.to_nn - y.to_nn, (x-y).to_nn)
  end
  def test_ただし答えが負になる場合はエラー
    x, y = 3, 4
    assert_raises(
      NewNum::UndefinedOperationError
    ){x.to_nn - y.to_nn}
  end
  def test_除算も可能
    x, y = 14, 3
    assert_equal(x.to_nn / y.to_nn, (x/y).to_nn)
  end
  def test_剰余も出て来る
    x, y = 14, 3
    assert_equal(x.to_nn % y.to_nn, (x%y).to_nn)
  end
  def test_ゼロ除算エラーも完備
    x = 1
    assert_raises(
      ZeroDivisionError
    ){x.to_nn / @zero}
    assert_raises(
      ZeroDivisionError
    ){x.to_nn % @zero}
  end
end


