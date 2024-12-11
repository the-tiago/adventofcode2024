defmodule Day11Test do
  use ExUnit.Case

  test "part 1" do
    input = "125 17"

    assert Day11.part1(input) == 55312
  end

  test "part 2" do
    input = "125 17"

    assert Day11.part2(input) == 65_601_038_650_482
  end
end
