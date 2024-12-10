defmodule Day10Test do
  use ExUnit.Case

  test "part 1" do
    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    assert Day10.part1(input) == 36
  end

  test "part 2" do
    input = """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """

    assert Day10.part2(input) == 81
  end
end
