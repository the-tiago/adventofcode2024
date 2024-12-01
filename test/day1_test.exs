defmodule Day1Test do
  use ExUnit.Case

  test "part1" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert Day1.part1(input) == 11
  end

  test "part2" do
    input = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """

    assert Day1.part2(input) == 31
  end
end
